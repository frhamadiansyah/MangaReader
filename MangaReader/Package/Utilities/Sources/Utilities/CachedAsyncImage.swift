import Combine
import SwiftUI

// AsyncImage from: https://github.com/V8tr/AsyncImage

public struct CustomAsyncImage: View {
    @StateObject private var loader: ImageLoader
    
    private let image: (UIImage) -> Image
    
    public init(
        url: String,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        self.image = image
        _loader = StateObject(
            wrappedValue: ImageLoader(url: URL(string: url)!,
                                      cache: Environment(\.imageCache).wrappedValue))
    }
    
    public var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                image(loader.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "arrow.clockwise")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        loader.load()
                    }
                    
            }
        }
    }
}

public protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

public class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private(set) var isLoading = false
    
    private let url: URL
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?
    
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoading else { return }
        
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
}

struct TemporaryImageCache: ImageCache {
    private let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 100 // 100 items
        cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB
        return cache
    }()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            newValue == nil ?
            cache.removeObject(forKey: key as NSURL) :
            cache.setObject(newValue!, forKey: key as NSURL)
            
        }
    }
}

public struct ImageCacheKey: EnvironmentKey {
    public static let defaultValue: ImageCache = TemporaryImageCache()
}

public extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

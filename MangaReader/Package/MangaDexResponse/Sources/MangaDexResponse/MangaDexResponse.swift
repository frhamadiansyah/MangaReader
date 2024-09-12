// The Swift Programming Language
// https://docs.swift.org/swift-book

public struct MangaDexResponse: Decodable {
    public let result: String
    public let response: String?
    public let data: MangaDexDataEnum?
    public let errors: [MangaDexErrorStruct]?
    public let baseUrl: String?
    public let chapter: ChapterImageUrlModel?
    public let statuses: [String: String]?
    public let token: [String: String]?
    
    public init() {
        result = "dummy"
        response = nil
        data = nil
        errors = nil
        baseUrl = nil
        chapter = nil
        statuses = nil
        token = nil
    }
}

public struct ChapterImageUrlModel: Decodable {
    public let hash: String
    public let data: [String]
    public let dataSaver: [String]
}

public struct MangaDexErrorStruct: Decodable, Error {
    public let id: String
    public let status: Int
    public let title: String
    
    public init(id: String, status: Int, title: String) {
        self.id = id
        self.status = status
        self.title = title
    }
}

//MARK: - MangaDex Data
public enum MangaDexDataEnum: Decodable {
    case collection([MangaDexData])
    case entity(MangaDexData)
    case noData
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([MangaDexData].self) {
            self = .collection(x)
            return
        } else if let x = try? container.decode(MangaDexData.self) {
            self = .entity(x)
            return
        } else {
            self = .noData
            return
        }
    }
}


public struct MangaDexData: Decodable {
    public let id: String
    public let type: MangaDexRelationshipType
    public let attributes: MangaDexAttributes
    public let relationships: [ChildMangaDexData]?
    
    public enum CodingKeys: String, CodingKey {
        case id
        case type
        case attributes
        case relationships
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
        let typeString = try container.decode(String.self, forKey: .type)
        type = MangaDexRelationshipType.init(rawValue: typeString) ?? .unknownType
        attributes = try container.decode(MangaDexAttributes.self, forKey: .attributes)
        
        relationships = try container.decode([ChildMangaDexData].self, forKey: .relationships)
    }
}

public struct ChildMangaDexData: Decodable {
    public let id: String
    public let type: MangaDexRelationshipType
    public var attributes: MangaDexAttributes? = nil
    public var related: String? = nil
    
    public enum CodingKeys: String, CodingKey {
        case id
        case type
        case attributes
        case related
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
        let typeString = try container.decode(String.self, forKey: .type)
        type = MangaDexRelationshipType.init(rawValue: typeString) ?? .unknownType
        if container.contains(.attributes) {
            attributes = try container.decode(MangaDexAttributes.self, forKey: .attributes)
        }
        if container.contains(.related) {
            related = try container.decode(String.self, forKey: .related)
        }
    }
}

//MARK: - MangaDex Attributes
public enum MangaDexAttributes: Decodable {

    case manga(RawMangaModel)
    case creator(RawCreatorModel)
    case cover(MangaCoverModel)
    case chapter(RawMangaChapterModel)
    case tag(RawTagModel)
    case unknown
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(RawMangaModel.self) {
            self = .manga(x)
            return
        } else if let x = try? container.decode(RawCreatorModel.self) {
            self = .creator(x)
            return
        } else if let x = try? container.decode(RawTagModel.self) {
            self = .tag(x)
            return
        } else if let x = try? container.decode(MangaCoverModel.self) {
            self = .cover(x)
            return
        } else if let x = try? container.decode(RawMangaChapterModel.self) {
            self = .chapter(x)
            return
        } else {
            self = .unknown
            return
        }
    }
}

public struct RawTagModel: Decodable {
    public let name: MultiLanguageText
}

public struct MangaCoverModel: Decodable {
    public let fileName: String
}


public struct RawCreatorModel: Decodable {
    public let name: String
}

public struct MultiLanguageText: Decodable {
    public let en: String?
    
    public enum CodingKeys: String, CodingKey {
        case en
    }
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            en = try container.decode(String.self, forKey: .en)
        } catch {
            en = ""
        }

    }
}

public struct RawMangaModel: Decodable {
    public let title: MultiLanguageText
    public let description: MultiLanguageText
    public let contentRating: ContentRating
    public let status: MangaStatus
    public let publicationDemographic: PublicationDemographic
    public let tags: [MangaDexData]
    
    public enum CodingKeys: String, CodingKey {
        case title
        case description
        case contentRating
        case status
        case publicationDemographic
        case tags
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(MultiLanguageText.self, forKey: .title)
        description = try container.decode(MultiLanguageText.self, forKey: .description)
        
        do {
            let rating = try container.decode(String.self, forKey: .contentRating)
            contentRating = ContentRating.init(rawValue: rating) ?? .unknown
        } catch {
            contentRating = .unknown
        }
        
        do {
            let mangaStatus = try container.decode(String.self, forKey: .status)
            status = MangaStatus.init(rawValue: mangaStatus) ?? .unknown
        } catch {
            status = .unknown
        }
        
        do {
            let demographic = try container.decode(String.self, forKey: .publicationDemographic)
            publicationDemographic = PublicationDemographic.init(rawValue: demographic) ?? .unknown
        } catch {
            publicationDemographic = .unknown
        }
        
        tags = try container.decode([MangaDexData].self, forKey: .tags)
    }

}


public struct RawMangaChapterModel: Decodable {
    public let chapter: String
    public let title: String?
    
}

public enum MangaDexRelationshipType: String {
    case manga = "manga"
    case chapter = "chapter"
    case artist = "artist"
    case author = "author"
    case cover = "cover_art"
    case scanlation = "scanlation_group"
    case unknownType = "unknownType"
}

//MARK: - Manga Enum
public enum ContentRating: String {
    case safeContent = "safe"
    case suggestive = "suggestive"
    case erotica = "erotica"
    case pornographic = "pornographic"
    case unknown
    
//    func getColor() -> Color {
//        switch self {
//        case .safeContent:
//            return Color.green
//        case .suggestive:
//            return Color.orange
//        case .erotica:
//            return Color.pink
//        case .pornographic:
//            return Color.red
//        case .unknown:
//            return Color.gray
//        }
//    }
}

public enum MangaStatus: String {
    case ongoing = "ongoing"
    case completed = "completed"
    case hiatus = "hiatus"
    case cancelled = "cancelled"
    case unknown
    
//    func getColor() -> Color {
//        switch self {
//        case .ongoing:
//            return Color.green
//        case .completed:
//            return Color.blue
//        case .hiatus:
//            return Color.orange
//        case .cancelled:
//            return Color.red
//        case .unknown:
//            return Color.gray
//        }
//    }
}

public enum PublicationDemographic: String {
    case shounen = "shounen"
    case shoujo = "shoujo"
    case josei = "josei"
    case seinen = "seinen"
    case unknown
}

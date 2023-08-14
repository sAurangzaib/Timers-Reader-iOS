
import Foundation


enum MediaType: String, Decodable {
    case image
    case video
}

struct News: Decodable {
    var webLink: URL?
    var newId: Int?
    var source: String?
    var publishedDate: String?
    var byline: String?
    var newsType: String?
    var title: String?
    var abstract: String?
    var adxKeywords: String?
    var desFacets: [String]?
    var orgFacets: [String]?
    var perFacets: [String]?
    var geoFacets: [String]?
    var media: [NewsMedia]?
}

extension News {
    
    static func mock(webLink: URL? = nil, newId: Int? = 0, source: String? = "Mock Source", publishedDate: String? = "Mock date", byline: String? = "Mock byline", newsType: String? = "Mock Type", title: String? = "Title", abstract: String? = "Mock Abstract", adxKeywords: String? = "Mocke keywords", desFacets: [String]? = [], orgFacets: [String]? = [], perFacets: [String]? = [], geoFacets: [String]? = [], media: [NewsMedia]? = []) -> News {
        
        
        News(webLink: webLink, newId: newId, source: source, publishedDate: publishedDate, byline: byline, newsType: newsType, title: title, abstract: abstract, adxKeywords: adxKeywords, desFacets: desFacets, orgFacets: orgFacets, perFacets: perFacets, geoFacets: geoFacets, media: media)
    }
}

extension News {

    enum CodingKeys: String, CodingKey {
        case webLink = "url"
        case newId = "id"
        case source
        case publishedDate = "published_date"
        case byline
        case newsType = "type"
        case title
        case abstract
        case adxKeywords = "adx_keywords"
        case desFacets = "des_facet"
        case orgFacets = "org_facet"
        case perFacets = "per_facet"
        case geoFacets = "geo_facet"
        case media
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        webLink = try values.decodeIfPresent(String.self, forKey: .webLink)?.toURL
        newId = try values.decodeIfPresent(Int.self, forKey: .newId)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        publishedDate = try values.decodeIfPresent(String.self, forKey: .publishedDate)
        byline = try values.decodeIfPresent(String.self, forKey: .byline)
        newsType = try values.decodeIfPresent(String.self, forKey: .newsType)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        abstract = try values.decodeIfPresent(String.self, forKey: .abstract)
        adxKeywords = try values.decodeIfPresent(String.self, forKey: .adxKeywords)
        desFacets = try values.decodeIfPresent([String].self, forKey: .desFacets)
        orgFacets = try values.decodeIfPresent([String].self, forKey: .orgFacets)
        perFacets = try values.decodeIfPresent([String].self, forKey: .perFacets)
        geoFacets = try values.decodeIfPresent([String].self, forKey: .geoFacets)
        media = try values.decodeIfPresent([NewsMedia].self, forKey: .media)
    }
}


struct NewsMedia: Decodable {
    let type: MediaType?
    let caption: String?
    let copyright: String?
    let metaData: [MediaMeta]?
}

extension NewsMedia {

    enum CodingKeys: String, CodingKey {
        case type
        case caption
        case copyright
        case metaData = "media-metadata"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(MediaType.self, forKey: .type)
        caption = try values.decodeIfPresent(String.self, forKey: .caption)
        copyright = try values.decodeIfPresent(String.self, forKey: .copyright)
        metaData = try values.decodeIfPresent([MediaMeta].self, forKey: .metaData)
    }
}

enum MediaformatType: String, Decodable {
    case stander = "Standard Thumbnail"
    case threeByTow210 = "mediumThreeByTwo210"
    case threeByTow440 = "mediumThreeByTwo440"
}

struct MediaMeta: Decodable {
    let mediaURL: URL?
    let format: MediaformatType?
}

extension MediaMeta {

    enum CodingKeys: String, CodingKey {
        case mediaURL = "url"
        case format
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mediaURL = try values.decodeIfPresent(String.self, forKey: .mediaURL)?.toURL
        format = try values.decodeIfPresent(MediaformatType.self, forKey: .format)
    }
}

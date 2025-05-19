import Foundation

struct BookResponse: Codable {
    let documents: [Book]
    let meta: Meta
}

struct Book: Codable {
    let title: String
    let contents: String
    let authors: [String]
    let salePrice: Int
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case title, contents, authors, thumbnail
        case salePrice = "sale_price"
    }
}

struct Meta: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}

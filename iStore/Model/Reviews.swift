import Foundation

struct Reviews: Decodable {
    let feed: ReviewFeed
}

struct ReviewFeed: Decodable {
    let entry: [Entry]
}

struct Entry: Decodable {
    let author: Author
    let title: Label
    let content: Label
}

struct Label: Decodable {
    let label: String
}

struct Author: Decodable {
    let name: Label
}

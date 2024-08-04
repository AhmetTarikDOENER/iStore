import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [App]
}

struct App: Decodable {
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Float?
}

import Foundation

struct AppResult: Decodable {
    let resultCount: Int
    let results: [App]
}

struct App: Decodable {
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Float?
    let screenshotUrls: [String]
    let artworkUrl100: String
}

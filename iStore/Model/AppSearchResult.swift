import Foundation

struct AppSearchResult: Decodable {
    let resultCount: Int
    let results: [AppSearch]
}

struct AppSearch: Decodable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Float?
    let screenshotUrls: [String]
    let artworkUrl100: String
    let formattedPrice: String
    let description: String
    let releaseNotes: String
}

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {  }
    
    func fetchApps(searchTerm: String, completion: @escaping (Result<[AppSearch], Error>) -> Void) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else { return }
            do {
                let searhcResult = try JSONDecoder().decode(AppSearchResult.self, from: data)
                completion(.success(searhcResult.results))
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchAppsForRows(completion: @escaping (Result<AppRowResults, Error>) -> Void) {
        guard let url = URL(string: "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/50/apps.json") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else { return }
            do {
                let appRows = try JSONDecoder().decode(AppRowResults.self, from: data)
                completion(.success(appRows))
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {  }
    
    func fetchApps(searchTerm: String, completion: @escaping (Result<AppSearchResult, Error>) -> Void) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        fetch(urlString: urlString, completion: completion)
    }
    
    func fetchTopFreeAppsForRows(completion: @escaping (Result<AppRowResults?, Error>) -> Void) {
        let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/50/apps.json"
        self.fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchTopPaidsAppsForRows(completion: @escaping (Result<AppRowResults?, Error>) -> Void) {
        let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/50/apps.json"
        self.fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchHeaderSocialApps(completion: @escaping (Result<[HeaderApps]?, Error>) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        fetch(urlString: urlString, completion: completion)
    }
    
    func fetchAppGroup(urlString: String, completion: @escaping (Result<AppRowResults?, Error>) -> Void) {
        fetch(urlString: urlString, completion: completion)
    }

    func fetch<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else { return }
            do {
                let apps = try JSONDecoder().decode(T.self, from: data)
                completion(.success(apps))
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

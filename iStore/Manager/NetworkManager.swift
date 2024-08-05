import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {  }
    
    func fetchApps(completion: @escaping (Result<[App], Error>) -> Void) {
        let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else { return }
            do {
                let searhcResult = try JSONDecoder().decode(AppResult.self, from: data)
                completion(.success(searhcResult.results))
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

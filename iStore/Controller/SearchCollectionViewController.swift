import UIKit

final class SearchCollectionViewController: UICollectionViewController {
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
        fetchITunesApps()
    }

    private func fetchITunesApps() {
        let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else { return }
            do {
                let searhcResult = try JSONDecoder().decode(SearchResult.self, from: data)
                searhcResult.results.forEach {
                    print($0.trackName, $0.primaryGenreName)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
//  MARK: - UICollectionViewDataSource:
extension SearchCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath) as! SearchResultsCollectionViewCell
        
        return cell
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 300)
    }
}

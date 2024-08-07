import UIKit

final class AppDetailCollectionViewController: RootListCollectionViewController {

    var id: String? {
        didSet {
            let urlString = "https://itunes.apple.com/lookup?id=\(id ?? "")"
            NetworkManager.shared.fetch(urlString: urlString) { (results: Result<AppSearchResult, Error>) in
                switch results {
                case .success(let appResult):
                    print(appResult.results.first?.releaseNotes ?? "")
                case .failure(let error):
                    ()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AppDetailCollectionViewCell.self, forCellWithReuseIdentifier: AppDetailCollectionViewCell.identifier)
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension AppDetailCollectionViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppDetailCollectionViewCell.identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 300)
    }
}

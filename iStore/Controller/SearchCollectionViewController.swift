import UIKit
import SDWebImage

final class SearchCollectionViewController: UICollectionViewController {
    
    private var appResults = [App]()
    
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
        fetchApps()
    }

    private func fetchApps() {
        NetworkManager.shared.fetchApps { results in
            switch results {
            case .success(let apps):
                DispatchQueue.main.async {
                    self.appResults = apps
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                ()
            }
        }
    }
}
//  MARK: - UICollectionViewDataSource:
extension SearchCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        appResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath) as! SearchResultsCollectionViewCell
        let appResult = appResults[indexPath.item]
        cell.nameLabel.text = appResult.trackName
        cell.categoryLabel.text = appResult.primaryGenreName
        cell.ratingLabel.text = "Rating: \(appResult.averageUserRating ?? 0)"
        let url = URL(string: appResult.artworkUrl100)
        cell.appIconImageView.sd_setImage(with: url)
        cell.screenShotImageView1.sd_setImage(with: URL(string: appResult.screenshotUrls[0]))
        if appResult.screenshotUrls.count > 1 {
            cell.screenShotImageView2.sd_setImage(with: URL(string: appResult.screenshotUrls[1]))
        }
        if appResult.screenshotUrls.count > 2 {
            cell.screenShotImageView3.sd_setImage(with: URL(string: appResult.screenshotUrls[2]))
        }

        return cell
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 300)
    }
}

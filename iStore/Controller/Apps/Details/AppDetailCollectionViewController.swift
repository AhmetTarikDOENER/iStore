import UIKit

final class AppDetailCollectionViewController: RootListCollectionViewController {

    var app: AppSearch?
    
    var id: String? {
        didSet {
            let urlString = "https://itunes.apple.com/lookup?id=\(id ?? "")"
            NetworkManager.shared.fetch(urlString: urlString) { (results: Result<AppSearchResult, Error>) in
                switch results {
                case .success(let appResult):
                    let app = appResult.results.first
                    self.app = app
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
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
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: PreviewCollectionViewCell.identifier)
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension AppDetailCollectionViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppDetailCollectionViewCell.identifier, for: indexPath) as! AppDetailCollectionViewCell
            cell.app = app
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCollectionViewCell.identifier, for: indexPath) as! PreviewCollectionViewCell
            cell.horizontalController.app = app
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            let tempCell = AppDetailCollectionViewCell(frame: .init(x: 0, y: 0, width: collectionView.frame.width, height: 1000))
            tempCell.app = app
            tempCell.layoutIfNeeded()
            let estimatedSize = tempCell.systemLayoutSizeFitting(.init(width: collectionView.frame.width, height: 1000))
            
            return .init(width: collectionView.frame.width, height: estimatedSize.height)
        } else {
            return .init(width: collectionView.frame.width, height: 475)
        }
    }
}

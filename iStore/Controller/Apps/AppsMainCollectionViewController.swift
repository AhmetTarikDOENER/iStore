import UIKit

final class AppsMainCollectionViewController: RootListCollectionViewController {
    
    var topFreeApps: AppRowResults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AppsGroupCollectionViewCell.self, forCellWithReuseIdentifier: AppsGroupCollectionViewCell.identifier)
        collectionView.register(AppsHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AppsHeaderReusableView.identifier)
        fetchData()
    }
    
    private func fetchData() {
        NetworkManager.shared.fetchTopFreeAppsForRows { results in
            switch results {
            case .success(let topFreeApps):
                DispatchQueue.main.async {
                    self.topFreeApps = topFreeApps
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension AppsMainCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsGroupCollectionViewCell.identifier, for: indexPath) as! AppsGroupCollectionViewCell
        cell.titleLabel.text = topFreeApps?.feed.title
        cell.horizontalCollectionViewController.horizontalTopFreeApps = topFreeApps
        cell.horizontalCollectionViewController.collectionView.reloadData()
        return cell
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension AppsMainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: AppsHeaderReusableView.identifier,
            for: indexPath
        )
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width, height: 250)
    }
}

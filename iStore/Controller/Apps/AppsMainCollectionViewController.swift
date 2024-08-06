import UIKit

final class AppsMainCollectionViewController: RootListCollectionViewController {
    
    var groups = [AppRowResults]()
    
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
                guard let topFreeApps else { return }
                DispatchQueue.main.async {
                    self.groups.append(topFreeApps)
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        NetworkManager.shared.fetchTopPaidsAppsForRows { results in
            switch results {
            case .success(let topPaidsApps):
                guard let topPaidsApps else { return }
                DispatchQueue.main.async {
                    self.groups.append(topPaidsApps)
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
        groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsGroupCollectionViewCell.identifier, for: indexPath) as! AppsGroupCollectionViewCell
        let appGroup = groups[indexPath.item]
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalCollectionViewController.horizontalTopFreeApps = appGroup
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
        .init(width: collectionView.frame.width, height: 0)
    }
}

import UIKit

final class AppsHeaderHorizontalCollectionViewController: HorizontalCollectionViewSnappingController {
    
    var headerApps = [HeaderApps]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(AppsHeaderReusableCollectionViewCell.self, forCellWithReuseIdentifier: AppsHeaderReusableCollectionViewCell.identifier)
    }
}

extension AppsHeaderHorizontalCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        headerApps.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsHeaderReusableCollectionViewCell.identifier, for: indexPath) as! AppsHeaderReusableCollectionViewCell
        let headerApps = headerApps[indexPath.item]
        cell.companyNameLabel.text = headerApps.name
        cell.titleLabel.text = headerApps.tagline
        cell.imageView.sd_setImage(with: URL(string: headerApps.imageUrl))
        return cell
    }
}

//  MARK: - UICollectionViewDelegateFlowLayout:
extension AppsHeaderHorizontalCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 50, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 16, bottom: 16, right: 16)
    }
}

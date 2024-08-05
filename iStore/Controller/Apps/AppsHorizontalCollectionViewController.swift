import UIKit

final class AppsHorizontalCollectionViewController: RootListCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(AppRowCollectionViewCell.self, forCellWithReuseIdentifier: AppRowCollectionViewCell.identifier)
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
}

extension AppsHorizontalCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        13
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppRowCollectionViewCell.identifier, for: indexPath)
        
        return cell
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension AppsHorizontalCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = (collectionView.frame.height - 24 - 20) / 3
        return .init(width: collectionView.frame.width - 60, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

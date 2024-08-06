import UIKit

final class AppsHeaderHorizontalCollectionViewController: RootListCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(AppsHeaderReusableCollectionViewCell.self, forCellWithReuseIdentifier: AppsHeaderReusableCollectionViewCell.identifier)
        configureHierarchy()
    }
    
    private func configureHierarchy() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
}

extension AppsHeaderHorizontalCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsHeaderReusableCollectionViewCell.identifier, for: indexPath) as! AppsHeaderReusableCollectionViewCell
        
        return cell
    }
}

//  MARK: - UICollectionViewDelegateFlowLayout:
extension AppsHeaderHorizontalCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 50, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 16, bottom: 16, right: 0)
    }
}

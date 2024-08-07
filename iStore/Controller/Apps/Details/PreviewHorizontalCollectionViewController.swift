import UIKit

final class PreviewHorizontalCollectionViewController: HorizontalCollectionViewSnappingController {
    
    var app: AppSearch? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PreviewHorizontalCollectionViewCell.self, forCellWithReuseIdentifier: PreviewHorizontalCollectionViewCell.identifier)
    }
}

extension PreviewHorizontalCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        app?.screenshotUrls.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewHorizontalCollectionViewCell.identifier, for: indexPath) as! PreviewHorizontalCollectionViewCell
        let screenShotUrl = app?.screenshotUrls[indexPath.item]
        cell.imageView.sd_setImage(with: URL(string: screenShotUrl ?? ""))
        return cell
    }
}

extension PreviewHorizontalCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 250, height: collectionView.frame.height - 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 20, bottom: 0, right: 20)
    }
}

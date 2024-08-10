import UIKit

final class TodayAppMultipleCollectionViewController: RootListCollectionViewController {
    
    var apps = [FeedResult]()
    private let spacing: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(TodayMultipleAppCollectionViewCell.self, forCellWithReuseIdentifier: TodayMultipleAppCollectionViewCell.identifier)
        collectionView.isScrollEnabled = false
    }
}

extension TodayAppMultipleCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, apps.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMultipleAppCollectionViewCell.identifier, for: indexPath) as! TodayMultipleAppCollectionViewCell
        cell.apps = apps[indexPath.item]
        return cell
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension TodayAppMultipleCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = (collectionView.frame.height - 3 * spacing) / 4
        return .init(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
}

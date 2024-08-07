import UIKit

class HorizontalCollectionViewSnappingController: UICollectionViewController {
    
    init() {
        let layout = SnappingLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

final class SnappingLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        let itemWidth = collectionView.frame.width - 60
        let itemSpace = itemWidth + minimumLineSpacing
        var currentItemPageNumber = round(collectionView.contentOffset.x / itemSpace)
        
        let vx = velocity.x
        if vx > 1 { currentItemPageNumber += 1 } else if vx < 0 { currentItemPageNumber -= 1 }
        let nearestPageOffset = currentItemPageNumber * itemSpace
        
        return .init(x: nearestPageOffset, y: parent.y)
    }
    
}

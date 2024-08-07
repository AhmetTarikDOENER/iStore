import UIKit

final class ReviewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ReviewCollectionViewCell"
    let horizontalReviewController = ReviewHorizontalCollectionViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemCyan
        addSubviews(horizontalReviewController.view)
        horizontalReviewController.view.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

import UIKit

final class ReviewHorizontalCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ReviewHorizontalCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

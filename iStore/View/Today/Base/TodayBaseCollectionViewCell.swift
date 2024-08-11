import UIKit

class TodayBaseCollectionViewCell: UICollectionViewCell {
    var todayItem: TodayCellItem!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: 10)
        layer.shadowColor = UIColor.label.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override var isHighlighted: Bool {
        didSet {
            var transform: CGAffineTransform = .identity
            if isHighlighted {
                transform = .init(scaleX: 0.9, y: 0.9)
            }
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: .curveEaseOut) {
                    self.transform = transform
                }
        }
    }
}

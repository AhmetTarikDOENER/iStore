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
}

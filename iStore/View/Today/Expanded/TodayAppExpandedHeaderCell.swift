import UIKit

final class TodayAppExpandedHeaderCell: UITableViewCell {
    
    let todayCell = TodayCollectionViewCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHierarchy() {
        contentView.addSubviews(todayCell)
        todayCell.fillSuperView()
    }
}

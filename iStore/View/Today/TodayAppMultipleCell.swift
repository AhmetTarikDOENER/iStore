import UIKit

final class TodayAppMultipleCell: UICollectionViewCell {
    
    static let identifier = "TodayAppMultipleCell"
    var todayItem: TodayCellItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
        }
    }
    
    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilizing your time", font: .boldSystemFont(ofSize: 28), numberOfLines: 2)
    let multipleAppsController = UIViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHierarchy() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        multipleAppsController.view.backgroundColor = .red
        let stackView = VerticalStackView(
            arrangedSubviews: [
                categoryLabel,
                titleLabel,
                multipleAppsController.view
            ],
            spacing: 12
        )
        addSubview(stackView)
        stackView.fillSuperView(.init(top: 24, left: 24, bottom: 24, right: 24))
    }
    
}



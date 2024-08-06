import UIKit

final class AppRowCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AppRowCollectionViewCell"
    
    let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 16, weight: .medium))
    let companyNameLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 13))
    let iconImageView = UIImageView(cornerRadius: 8)
    let getButton = UIButton(title: "GET")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHierarchy() {
        iconImageView.backgroundColor = .label
        nameLabel.numberOfLines = 2
        nameLabel.minimumScaleFactor = 0.75
        nameLabel.adjustsFontSizeToFitWidth = true
        getButton.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        getButton.layer.cornerRadius = 16
        getButton.setTitleColor(.label, for: .normal)
        let stackView = UIStackView(
            arrangedSubviews: [
                iconImageView,
                VerticalStackView(arrangedSubviews: [nameLabel, companyNameLabel]),
                getButton
            ]
        )
        contentView.addSubview(stackView)
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        stackView.fillSuperView()
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 64),
            iconImageView.heightAnchor.constraint(equalToConstant: 64),
            getButton.widthAnchor.constraint(equalToConstant: 80),
            getButton.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
}

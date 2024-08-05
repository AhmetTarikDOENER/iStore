import UIKit

final class AppRowCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AppRowCollectionViewCell"
    
    private let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 20))
    private let companyNameLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 13))
    private let iconImageView = UIImageView(cornerRadius: 8)
    private let getButton = UIButton(title: "GET")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHierarchy() {
        iconImageView.backgroundColor = .label
        getButton.backgroundColor = .lightGray
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

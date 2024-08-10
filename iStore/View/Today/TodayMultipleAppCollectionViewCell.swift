import UIKit

final class TodayMultipleAppCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TodayMultipleAppCollectionViewCell"
    
    var apps: FeedResult! {
        didSet {
            nameLabel.text = apps.name
            companyNameLabel.text = apps.artistName
            iconImageView.sd_setImage(with: URL(string: apps.artworkUrl100))
        }
    }
    
    let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 16, weight: .medium))
    let companyNameLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 13))
    let iconImageView = UIImageView(cornerRadius: 8)
    let getButton = UIButton(title: "GET")
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
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
        contentView.addSubview(separatorView)
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 64),
            iconImageView.heightAnchor.constraint(equalToConstant: 64),
            getButton.widthAnchor.constraint(equalToConstant: 80),
            getButton.heightAnchor.constraint(equalToConstant: 32),
            separatorView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4),
            separatorView.heightAnchor.constraint(equalToConstant: 0.1)
        ])
    }
}

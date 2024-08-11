import UIKit

final class TodayCollectionViewCell: TodayBaseCollectionViewCell {
    
    static let identifier = "TodayCollectionViewCell"
    
    var topConstraint: NSLayoutConstraint?
    override var todayItem: TodayCellItem! {
        didSet {
            categoryLabel.text = todayItem.category
            categoryLabel.textColor = .black
            titleLabel.text = todayItem.title
            imageView.image = todayItem.image
            descriptionLabel.text = todayItem.description
            backgroundColor = todayItem.backgroundColor
            backgroundView?.backgroundColor = todayItem.backgroundColor
        }
    }
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "garden"))
    let categoryLabel = UILabel(text: "LIFE HACK", font: .systemFont(ofSize: 20, weight: .black))
    let titleLabel = UILabel(text: "Utilizing your time", font: .boldSystemFont(ofSize: 28))
    let descriptionLabel = UILabel(text: "All the tools and apps you need to intelegently orginize your life the right away", font: .boldSystemFont(ofSize: 16), numberOfLines: 3)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHierarchy() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        titleLabel.textColor = .black
        descriptionLabel.textColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageContainerView = UIView()
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(imageView)
        let stackView = VerticalStackView(
            arrangedSubviews: [categoryLabel, titleLabel, imageContainerView, descriptionLabel],
            spacing: 8
        )
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
        ])
        self.topConstraint = stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        self.topConstraint?.isActive = true
    }
}

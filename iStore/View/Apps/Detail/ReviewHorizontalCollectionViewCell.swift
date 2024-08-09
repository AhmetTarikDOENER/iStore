import UIKit

final class ReviewHorizontalCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ReviewHorizontalCollectionViewCell"
    let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 16))
    let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
    let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 13))
    let bodyLabel = UILabel(text: "Review body goes here\nReview body goes hereaiudadhaldsjlakjdslkasdlkasdlkajdbla", font: .systemFont(ofSize: 16), numberOfLines: 0)
    
    let starsStackView: UIStackView = {
        var arrangedSubviews = [UIView]()
        (0..<5).forEach { _ in
            let imageView = UIImageView(image: #imageLiteral(resourceName: "star"))
            imageView.contentMode = .scaleAspectFit
            imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            arrangedSubviews.append(imageView)
        }
        arrangedSubviews.append(UIView())
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        layer.cornerRadius = 16
        clipsToBounds = true
        let stackView = VerticalStackView(
            arrangedSubviews: [
                UIStackView(arrangedSubviews: [
                    titleLabel, authorLabel
                ], customSpacing: 8),
                starsStackView,
                bodyLabel
            ],
            spacing: 12
        )
        authorLabel.textAlignment = .right
        titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        addSubviews(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

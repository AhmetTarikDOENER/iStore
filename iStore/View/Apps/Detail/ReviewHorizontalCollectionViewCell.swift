import UIKit

final class ReviewHorizontalCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ReviewHorizontalCollectionViewCell"
    let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 16))
    let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
    let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 13))
    let bodyLabel = UILabel(text: "Review body goes here\nReview body goes hereaiudadhaldsjlakjdslkasdlkasdlkajdbla", font: .systemFont(ofSize: 14), numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        layer.cornerRadius = 16
        clipsToBounds = true
        let stackView = VerticalStackView(
            arrangedSubviews: [
                UIStackView(arrangedSubviews: [
                    titleLabel, UIView(), authorLabel
                ]),
                starsLabel,
                bodyLabel
            ],
            spacing: 12
        )
        addSubviews(stackView)
        stackView.fillSuperView(.init(top: 20, left: 12, bottom: 20, right: 12))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

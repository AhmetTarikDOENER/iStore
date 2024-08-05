import UIKit

final class AppsHeaderReusableCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AppsHeaderReusableCollectionViewCell"
    
    private let companyNameLabel = UILabel(text: "Facebook", font: .boldSystemFont(ofSize: 12))
    private let titleLabel = UILabel(text: "Keep up with friends is faster than ever.", font: .systemFont(ofSize: 23))
    private let imageView = UIImageView(cornerRadius: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHierarchy() {
        imageView.backgroundColor = .systemRed
        titleLabel.numberOfLines = 2
        companyNameLabel.textColor = .systemBlue
        let stackView = VerticalStackView(arrangedSubviews: [
            companyNameLabel,
            titleLabel,
            imageView
        ])
        contentView.addSubview(stackView)
        stackView.spacing = 8
        stackView.fillSuperView(.init(top: 12, left: 0, bottom: 0, right: 0))
    }
    
}

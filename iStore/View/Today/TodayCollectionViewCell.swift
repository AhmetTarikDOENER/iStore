import UIKit

final class TodayCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TodayCollectionViewCell"
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "garden"))

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
        clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
}

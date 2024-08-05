import UIKit

final class AppsGroupCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AppsGroupCollectionViewCell"
    
    private let titleLabel = UILabel(text: "App Section", font: .boldSystemFont(ofSize: 25))
    private let horizontalCollectionViewController = AppsHorizontalCollectionViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHierarchy() {
        contentView.addSubviews(titleLabel, horizontalCollectionViewController.view)
        horizontalCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalCollectionViewController.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            horizontalCollectionViewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalCollectionViewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalCollectionViewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}

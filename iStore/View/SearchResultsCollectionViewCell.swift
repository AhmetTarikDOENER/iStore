import UIKit

final class SearchResultsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchResultsCollectionViewCell"
    
    lazy var screenShotImageView1 = createScreenShotImageView()
    lazy var screenShotImageView2 = createScreenShotImageView()
    lazy var screenShotImageView3 = createScreenShotImageView()
    
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalToConstant: 65).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "APP NAME"
        
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Photos & Videos"
        
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1.23M"
        
        return label
    }()
    
    private let getButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("GET", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = .quaternaryLabel
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 15

        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func createScreenShotImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        
        return imageView
    }
    
    private func configureHierarchy() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let infoTopStackView = UIStackView(
            arrangedSubviews: [
                appIconImageView,
                VerticalStackView(arrangedSubviews: [nameLabel, categoryLabel, ratingLabel]),
                getButton
            ]
        )
        infoTopStackView.spacing = 12
        infoTopStackView.alignment = .center
        let screenShotStackView = UIStackView(arrangedSubviews: [screenShotImageView1, screenShotImageView2, screenShotImageView3])
        screenShotStackView.spacing = 12
        screenShotStackView.distribution = .fillEqually
        let overallStackView = VerticalStackView(arrangedSubviews: [infoTopStackView, screenShotStackView], spacing: 15)
        addSubview(overallStackView)
        overallStackView.directionalLayoutMargins = .init(top: 0, leading: 15, bottom: 15, trailing: 15)
        overallStackView.fillSuperView()
    }
}

import UIKit

final class SearchResultsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchResultsCollectionViewCell"
    
    var appResult: App! {
        didSet {
            nameLabel.text = appResult.trackName
            categoryLabel.text = appResult.primaryGenreName
            ratingLabel.text = "Rating: \(appResult.averageUserRating ?? 0)"
            let url = URL(string: appResult.artworkUrl100)
            appIconImageView.sd_setImage(with: url)
            screenShotImageView1.sd_setImage(with: URL(string: appResult.screenshotUrls[0]))
            if appResult.screenshotUrls.count > 1 {
                screenShotImageView2.sd_setImage(with: URL(string: appResult.screenshotUrls[1]))
            }
            if appResult.screenshotUrls.count > 2 {
                screenShotImageView3.sd_setImage(with: URL(string: appResult.screenshotUrls[2]))
            }
        }
    }
    
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
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        
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
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        imageView.contentMode = .scaleAspectFill
        
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

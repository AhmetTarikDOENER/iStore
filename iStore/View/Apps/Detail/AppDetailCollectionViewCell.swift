import UIKit

final class AppDetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AppDetailCollectionViewCell"
    
    var app: AppSearch? {
        didSet {
            nameLabel.text = app?.trackName
            releaseNotesLabel.text = app?.releaseNotes
            appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
            releaseNotesLabel.text = app?.releaseNotes
            priceButton.setTitle(app?.formattedPrice, for: .normal)
        }
    }
    
    let appIconImageView = UIImageView(cornerRadius: 16)
    let nameLabel = UILabel(text: "APP NAME", font: .boldSystemFont(ofSize: 22), numberOfLines: 2)
    let priceButton = UIButton(title: "$4.99")
    let whatsNewLabel = UILabel(text: "What's New", font: .boldSystemFont(ofSize: 20))
    let releaseNotesLabel = UILabel(text: "Release Notes", font: .systemFont(ofSize: 16), numberOfLines: 0)
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHiearchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configureHiearchy() {
        appIconImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        appIconImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        priceButton.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.4352941176, blue: 0.9607843137, alpha: 1)
        priceButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        priceButton.layer.cornerRadius = 13
        priceButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        priceButton.setTitleColor(.label, for: .normal)
        priceButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        let stackView = VerticalStackView(
            arrangedSubviews: [
                UIStackView(
                    arrangedSubviews: [
                        appIconImageView,
                        VerticalStackView(arrangedSubviews: [
                            nameLabel,
                            UIStackView(arrangedSubviews: [priceButton, UIView()]),
                            UIView()
                        ], spacing: 12)], customSpacing: 20
                ),
                whatsNewLabel,
                releaseNotesLabel
            ],
            spacing: 16
        )
        contentView.addSubview(stackView)
        stackView.fillSuperView(.init(top: 20, left: 20, bottom: 20, right: 20))
    }
}

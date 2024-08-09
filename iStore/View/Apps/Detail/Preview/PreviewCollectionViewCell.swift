import UIKit

final class PreviewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PreviewCollectionViewCell"
    let previewLabel = UILabel(text: "Preview", font: .boldSystemFont(ofSize: 22))
    let horizontalPreviewController = PreviewHorizontalCollectionViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(horizontalPreviewController.view, previewLabel)
        horizontalPreviewController.view.fillSuperView()
        NSLayoutConstraint.activate([
            previewLabel.topAnchor.constraint(equalTo: topAnchor),
            previewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            previewLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

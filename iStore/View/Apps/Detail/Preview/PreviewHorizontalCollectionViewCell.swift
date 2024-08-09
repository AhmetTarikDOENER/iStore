import UIKit

final class PreviewHorizontalCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PreviewHorizontalCollectionViewCell"
    
    let imageView = UIImageView(cornerRadius: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.backgroundColor = .lightGray
        imageView.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

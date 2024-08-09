import UIKit

final class AppsHeaderReusableView: UICollectionReusableView {
    
    static let identifier = "AppsHeaderReusableView_header"
    
    let headerHorizontalReusableController = AppsHeaderHorizontalCollectionViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHierarchy() {
        addSubviews(headerHorizontalReusableController.view)
        headerHorizontalReusableController.view.fillSuperView()
    }
}

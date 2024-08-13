import UIKit

final class CompositionalHeaderReusableView: UICollectionReusableView {
    
    let sectionHeaderLabel = UILabel(text: "Top Free Apps", font: .boldSystemFont(ofSize: 28))
    
    static let identifier = "CompositionalHeaderReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHiearchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHiearchy() {
        backgroundColor = .systemBackground
        addSubview(sectionHeaderLabel)
        sectionHeaderLabel.fillSuperView()
    }
}


import UIKit

final class VerticalStackView: UIStackView {
    
    init(arrangedSubviews: [UIView], spacing: CGFloat = 0) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        arrangedSubviews.forEach { addArrangedSubview($0) }
        self.axis = .vertical
        self.spacing = spacing
        self.isLayoutMarginsRelativeArrangement = true
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}

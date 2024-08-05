import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.font = font
    }
}

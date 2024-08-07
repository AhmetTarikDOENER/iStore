import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.font = font
        self.numberOfLines = numberOfLines
    }
}

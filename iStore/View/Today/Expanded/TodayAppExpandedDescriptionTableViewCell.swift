import UIKit

final class TodayAppExpandedDescriptionTableViewCell: UITableViewCell {
    
    static let identifier = "TodayAppExpandedDescriptionTableViewCell"
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(
            string: "Great Games",
            attributes: [.foregroundColor: UIColor.label]
        )
        attributedText.append(NSAttributedString(string: " is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", attributes: [.foregroundColor : UIColor.lightGray]))
        attributedText.append(NSAttributedString(string: "\n\n\nit was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages", attributes: [.foregroundColor : UIColor.label]))
        attributedText.append(NSAttributedString(string: "\nIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here", attributes: [.foregroundColor : UIColor.lightGray]))
        attributedText.append(NSAttributedString(string: "\nOn the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish.", attributes: [.foregroundColor : UIColor.lightGray]))
        attributedText.append(NSAttributedString(string: "\nIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here", attributes: [.foregroundColor : UIColor.lightGray]))
       
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.attributedText = attributedText
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHierarchy() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.fillSuperView(.init(top: 0, left: 24, bottom: 0, right: 24))
    }
}

import UIKit

final class TodayAppExpandedViewController: UIViewController {
    
    var dismissHandler: (() -> Void)?
    var todayItem: TodayCellItem?
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close_button"), for: .normal)
        
        return button
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        prepareTableView()
        configureCloseButton()
    }
    
    private func configureCloseButton() {
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 80),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
        ])
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    private func prepareTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.fillSuperView()
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
        configureFloatingControlsView()
    }
    
    private func configureFloatingControlsView() {
        let floatingContainerView = UIView()
        floatingContainerView.translatesAutoresizingMaskIntoConstraints = false
        floatingContainerView.layer.cornerRadius = 16
        floatingContainerView.clipsToBounds = true
        view.addSubview(floatingContainerView)
        NSLayoutConstraint.activate([
            floatingContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            floatingContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            floatingContainerView.heightAnchor.constraint(equalToConstant: 90)
        ])
        let blurredVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialLight))
        floatingContainerView.addSubview(blurredVisualEffectView)
        blurredVisualEffectView.fillSuperView()
        let imageView = UIImageView(cornerRadius: 16)
        imageView.image = todayItem?.image
        imageView.widthAnchor.constraint(equalToConstant: 58).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 58).isActive = true
        let getButton = UIButton(title: "GET")
        getButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        getButton.setTitleColor(.white, for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        getButton.backgroundColor = .darkGray
        getButton.layer.cornerRadius = 16
        let verticalStackView = VerticalStackView(
            arrangedSubviews: [
                UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 18)),
                UILabel(text: "Utilizing your time", font: .systemFont(ofSize: 16))
            ]
        )
        verticalStackView.isLayoutMarginsRelativeArrangement = false
        let stackView = UIStackView(
            arrangedSubviews: [
                imageView,
                verticalStackView,
                getButton
            ], customSpacing: 16)
        stackView.alignment = .center
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperView(.init(top: 0, left: 16, bottom: 0, right: 16))
        
    }
    
    @objc private func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
}

extension TodayAppExpandedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let headerCell = TodayAppExpandedHeaderCell()
            headerCell.todayCell.todayItem = todayItem
            headerCell.clipsToBounds = true
            headerCell.todayCell.backgroundView = nil
            return headerCell
        }
        let cell = TodayAppExpandedDescriptionTableViewCell()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return TodayCollectionViewController.cellSize
        }
        return UITableView.automaticDimension
    }
}

import UIKit

final class TodayCollectionViewController: RootListCollectionViewController {
    
    var startingFrame: CGRect?
    var expandedViewController: TodayAppExpandedTableViewController!
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    static let cellSize: CGFloat = 500
    
    let items = [
        TodayCellItem.init(category: "LIFE HACK", title: "Utilizing yout time", description: "All the tools and apps you need to intelegently orginize your life the right away", image: #imageLiteral(resourceName: "garden"), backgroundColor: .secondarySystemBackground, cellType: .single),
        TodayCellItem.init(category: "HOLIDAYS", title: "Travel on a budget", description: "All you need to know how to travel without packing everthing", image: #imageLiteral(resourceName: "holiday"), backgroundColor: #colorLiteral(red: 0.9803921569, green: 0.9607843137, blue: 0.7254901961, alpha: 1), cellType: .single),
        TodayCellItem.init(category: "THE DAILY LIST", title: "Test drive these CarPlay apps", description: "All you need to know how to travel without packing everthing", image: #imageLiteral(resourceName: "garden"), backgroundColor: .secondarySystemBackground, cellType: .multiple)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: TodayCellItem.CellType.single.rawValue)
        collectionView.register(TodayAppMultipleCell.self, forCellWithReuseIdentifier: TodayCellItem.CellType.multiple.rawValue)
    }
    
    @objc private func handleRemoveExpandedView() {
        self.navigationController?.navigationBar.isHidden = false
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: {
            self.expandedViewController.tableView.contentOffset = .zero
            guard let startingFrame = self.startingFrame else { return }
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            self.view.layoutIfNeeded()
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
            }
            guard let cell = self.expandedViewController.tableView.cellForRow(at: [0, 0]) as? TodayAppExpandedHeaderCell else { return }
            cell.todayCell.topConstraint?.constant = 68
            cell.layoutIfNeeded()
        }, completion: { _ in
            self.expandedViewController.view.removeFromSuperview()
            self.expandedViewController.removeFromParent()
        })
    }
}

extension TodayCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = items[indexPath.item].cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType, for: indexPath)
        if let cell = cell as? TodayCollectionViewCell {
            cell.todayItem = items[indexPath.item]
        } else if let cell = cell as? TodayAppMultipleCell {
            cell.todayItem = items[indexPath.item]
        }
        return cell
    }
}

//  MARK: - UICollectionViewDelegateFlowLayout:
extension TodayCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 60, height: TodayCollectionViewController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 30, left: 0, bottom: 30, right: 0)
    }
    
    @objc private func didHandleRemove(gesture: UITapGestureRecognizer) {
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .curveEaseOut, animations: {
                self.expandedViewController.tableView.contentOffset = .zero
                guard let startingFrame = self.startingFrame else { return }
                self.topConstraint?.constant = startingFrame.origin.y
                self.leadingConstraint?.constant = startingFrame.origin.x
                self.widthConstraint?.constant = startingFrame.width
                self.heightConstraint?.constant = startingFrame.height
                if let tabBarFrame = self.tabBarController?.tabBar.frame {
                    self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
                }
                guard let cell = self.expandedViewController.tableView.cellForRow(at: [0, 0]) as? TodayAppExpandedHeaderCell else { return }
                cell.todayCell.topConstraint?.constant = 24
                cell.layoutIfNeeded()
            }) { _ in
                gesture.view?.removeFromSuperview()
                self.expandedViewController.removeFromParent()
                self.collectionView.isUserInteractionEnabled = true
            }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let expandedViewController = TodayAppExpandedTableViewController()
        expandedViewController.todayItem = items[indexPath.item]
        expandedViewController.dismissHandler = {
            self.handleRemoveExpandedView()
        }
        guard let expandedView = expandedViewController.view else { return }
        expandedView.layer.cornerRadius = 12
        expandedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didHandleRemove)))
        view.addSubview(expandedView)
        addChild(expandedViewController)
        self.expandedViewController = expandedViewController
        self.collectionView.isUserInteractionEnabled = false
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
        expandedView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = expandedView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = expandedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = expandedView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = expandedView.heightAnchor.constraint(equalToConstant: startingFrame.height)
        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach{ $0?.isActive = true }
        self.view.layoutIfNeeded()
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut) {
                self.topConstraint?.constant = 0
                self.leadingConstraint?.constant = 0
                self.widthConstraint?.constant = self.view.frame.width
                self.heightConstraint?.constant = self.view.frame.height
                self.view.layoutIfNeeded()
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
                guard let cell = expandedViewController.tableView.cellForRow(at: [0, 0]) as? TodayAppExpandedHeaderCell else { return }
                cell.todayCell.topConstraint?.constant = 70
                cell.layoutIfNeeded()
            }
    }
}

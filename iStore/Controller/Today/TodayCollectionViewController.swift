import UIKit

final class TodayCollectionViewController: RootListCollectionViewController {
    
    static let cellSize: CGFloat = 500
    
    var items = [TodayCellItem]()
    
    var startingFrame: CGRect?
    var expandedViewController: TodayAppExpandedViewController!
    var expandedViewBeginOffset: CGFloat = 0
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    private let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        collectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: TodayCellItem.CellType.single.rawValue)
        collectionView.register(TodayAppMultipleCell.self, forCellWithReuseIdentifier: TodayCellItem.CellType.multiple.rawValue)
        fetchData()
    }
    
    private func configureHierarchy() {
        navigationController?.isNavigationBarHidden = true
        collectionView.backgroundColor = .systemBackground
        view.addSubviews(activityIndicatorView, blurVisualEffectView)
        blurVisualEffectView.fillSuperView()
        blurVisualEffectView.isHidden = true
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 120),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        var group1: AppRowResults?
        var group2: AppRowResults?
        dispatchGroup.enter()
        NetworkManager.shared.fetchTopPaidsAppsForRows { results in
            switch results {
            case .success(let topPaidApps):
                guard let topPaidApps else { return }
                group1 = topPaidApps
            case .failure(let error):
                print(error.localizedDescription)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        NetworkManager.shared.fetchTopFreeAppsForRows { results in
            switch results {
            case .success(let topFreeApps):
                guard let topFreeApps else { return }
                group2 = topFreeApps
            case .failure(let error):
                print(error.localizedDescription)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.items = [
                TodayCellItem.init(
                    category: "HOLIDAYS",
                    title: "Travel on a Budget",
                    description: "All you need to know how to travel without packing everthing",
                    image: #imageLiteral(resourceName: "holiday"),
                    backgroundColor: #colorLiteral(red: 0.9803921569, green: 0.9607843137, blue: 0.7254901961, alpha: 1),
                    cellType: .single,
                    apps: []
                ),
                TodayCellItem.init(
                    category: "Daily List",
                    title: group1?.feed.title ?? "",
                    description: "All the tools and apps you need to intelegently orginize your life the right away",
                    image: #imageLiteral(resourceName: "garden"),
                    backgroundColor: .secondarySystemBackground,
                    cellType: .multiple, apps: group1?.feed.results ?? []
                ),
                TodayCellItem.init(
                    category: "Daily List",
                    title: group2?.feed.title ?? "",
                    description: "All the tools and apps you need to intelegently orginize your life the right away",
                    image: #imageLiteral(resourceName: "garden"),
                    backgroundColor: .secondarySystemBackground,
                    cellType: .multiple, apps: group2?.feed.results ?? []
                )
            ]
            self.activityIndicatorView.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    @objc private func handleRemoveExpandedView() {
        self.blurVisualEffectView.isHidden = true
        self.expandedViewController.view.transform = .identity
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
            self.expandedViewController.closeButton.isHidden = true
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType, for: indexPath) as! TodayBaseCollectionViewCell
        cell.todayItem = items[indexPath.row]
        (cell as? TodayAppMultipleCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapApp)))
        
        return cell
    }
    
    @objc private func didTapApp(gesture: UITapGestureRecognizer) {
        let collectionView = gesture.view
        var superview = collectionView?.superview
        while superview != nil {
            if let cell = superview as? TodayAppMultipleCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                let apps = self.items[indexPath.item].apps
                let fullScreenController = TodayAppMultipleCollectionViewController(presentationMode: .fullscreen)
                fullScreenController.modalPresentationStyle = .fullScreen
                fullScreenController.apps = apps
                let navVC = TodayNavigationBarBackEnabledController(rootViewController: fullScreenController)
                navVC.modalPresentationStyle = .fullScreen
                navigationController?.present(navVC, animated: true)
                return
            }
            superview = superview?.superview
        }
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
    
    private func showDailyListCategeroyInFullScreenMode(for indexPath: IndexPath) {
        let fullScreenController = TodayAppMultipleCollectionViewController(presentationMode: .fullscreen)
        fullScreenController.apps = self.items[indexPath.item].apps
        let fullScreenNavController = TodayNavigationBarBackEnabledController(rootViewController: fullScreenController)
        fullScreenNavController.modalPresentationStyle = .fullScreen
        navigationController?.present(fullScreenNavController, animated: true)
    }
    
    private func setupExpandedViewController(for indexPath: IndexPath) {
        let expandedViewController = TodayAppExpandedViewController()
        expandedViewController.todayItem = items[indexPath.item]
        expandedViewController.dismissHandler = {
            self.handleRemoveExpandedView()
        }
        expandedViewController.view.layer.cornerRadius = 12
        self.expandedViewController = expandedViewController
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDragging))
        gestureRecognizer.delegate = self
        expandedViewController.view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func handleDragging(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            expandedViewBeginOffset = expandedViewController.tableView.contentOffset.y
        }
        if expandedViewController.tableView.contentOffset.y > 0 {
            return
        }
        let translationY = gesture.translation(in: expandedViewController.view).y
        switch gesture.state {
        case .changed:
            if translationY > 0 {
                let dOffset = translationY - expandedViewBeginOffset
                var scale = 1 - dOffset / 1000
                scale = min(1, scale)
                scale = max(0.5, scale)
                let transform = CGAffineTransform.init(scaleX: scale, y: scale)
                self.expandedViewController.view.transform = transform
            }
        case .ended:
            if translationY > 0 {
                handleRemoveExpandedView()
            }
        default: break
        }
    }
    
    private func setupStartingFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
    }
    
    private func configureFullScreenStartingFrame(for indexPath: IndexPath) {
        guard let expandedView = expandedViewController.view else { return }
        expandedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didHandleRemove)))
        view.addSubview(expandedView)
        addChild(expandedViewController)
        setupStartingFrame(indexPath)
        guard let startingFrame else { return }
        expandedView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = expandedView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = expandedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = expandedView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = expandedView.heightAnchor.constraint(equalToConstant: startingFrame.height)
        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach{ $0?.isActive = true }
        self.view.layoutIfNeeded()
    }
    
    fileprivate func beginFullScreenAnimation() {
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            self.blurVisualEffectView.isHidden = false
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            self.view.layoutIfNeeded()
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
            guard let cell = self.expandedViewController.tableView.cellForRow(at: [0, 0]) as? TodayAppExpandedHeaderCell else { return }
            cell.todayCell.topConstraint?.constant = 70
            cell.layoutIfNeeded()
        }
    }
    
    private func showOtherListCategoryInFullScreenMode(for indexPath: IndexPath) {
        setupExpandedViewController(for: indexPath)
        configureFullScreenStartingFrame(for: indexPath)
        beginFullScreenAnimation()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.item].cellType {
        case .multiple: showDailyListCategeroyInFullScreenMode(for: indexPath)
        default: showOtherListCategoryInFullScreenMode(for: indexPath)
        }
    }
}

//  MARK: - UIGestureRecognizerDelegate:
extension TodayCollectionViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true /// for to be enable scrolling behaviour after adding gesture
    }
}

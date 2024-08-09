import UIKit

final class TodayCollectionViewController: RootListCollectionViewController {
    
    var startingFrame: CGRect?
    var expandedViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: TodayCollectionViewCell.identifier)
    }
}

extension TodayCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCollectionViewCell.identifier, for: indexPath)
        
        return cell
    }
}

//  MARK: - UICollectionViewDelegateFlowLayout:
extension TodayCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width - 60, height: 450)
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
                gesture.view?.frame = self.startingFrame ?? .zero
                if let tabBarFrame = self.tabBarController?.tabBar.frame {
                    self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
                }
            }) { _ in
                gesture.view?.removeFromSuperview()
                self.expandedViewController.removeFromParent()
            }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let expandedViewController = TodayAppExpandedTableViewController()
        guard let expandedView = expandedViewController.view else { return }
        expandedView.layer.cornerRadius = 12
        expandedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didHandleRemove)))
        view.addSubview(expandedView)
        addChild(expandedViewController)
        self.expandedViewController = expandedViewController
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
        expandedView.frame = startingFrame
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut) {
                expandedView.frame = self.view.frame
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
            }
    }
}

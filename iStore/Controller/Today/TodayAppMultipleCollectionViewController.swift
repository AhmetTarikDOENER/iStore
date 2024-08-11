import UIKit

final class TodayAppMultipleCollectionViewController: RootListCollectionViewController {
    
    enum PresentationMode {
        case small, fullscreen
    }
    
    init(presentationMode: PresentationMode) {
        self.presentationMode = presentationMode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var apps = [FeedResult]()
    private let presentationMode: PresentationMode
    private let spacing: CGFloat = 20
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close_button"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(TodayMultipleAppCollectionViewCell.self, forCellWithReuseIdentifier: TodayMultipleAppCollectionViewCell.identifier)
        if presentationMode == .fullscreen {
            configureCloseButton()
            navigationController?.isNavigationBarHidden = true
        } else {
            collectionView.isScrollEnabled = false
        }
    }
    
    override var prefersStatusBarHidden: Bool { true }
    
    private func configureCloseButton() {
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            closeButton.widthAnchor.constraint(equalToConstant: 80),
            closeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
}

extension TodayAppMultipleCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if presentationMode == .fullscreen {
            return apps.count
        }
        return min(4, apps.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMultipleAppCollectionViewCell.identifier, for: indexPath) as! TodayMultipleAppCollectionViewCell
        cell.apps = apps[indexPath.item]
        return cell
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension TodayAppMultipleCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appDetailController = AppDetailCollectionViewController(id: apps[indexPath.item].id)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 80
        if presentationMode == .fullscreen {
            return .init(width: collectionView.frame.width - 40, height: height)
        }
        return .init(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if presentationMode == .fullscreen {
            return .init(top: 16, left: 20, bottom: 16, right: 20)
        }
        return .zero
    }
}

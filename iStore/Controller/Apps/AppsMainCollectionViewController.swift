import UIKit

final class AppsMainCollectionViewController: RootListCollectionViewController {
    
    var groups = [AppRowResults]()
    var headerApps = [HeaderApps]()
    
    private let indicatorView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .label
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        collectionView.register(AppsGroupCollectionViewCell.self, forCellWithReuseIdentifier: AppsGroupCollectionViewCell.identifier)
        collectionView.register(AppsHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AppsHeaderReusableView.identifier)
        fetchData()
    }
    
    private func configureHierarchy() {
        view.addSubview(indicatorView)
        indicatorView.fillSuperView()
        collectionView.backgroundColor = .systemBackground
    }
    
    private func fetchData() {
        var group1: AppRowResults?
        var group2: AppRowResults?
        var group3: [HeaderApps]?
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        NetworkManager.shared.fetchTopFreeAppsForRows { results in
            dispatchGroup.leave()
            switch results {
            case .success(let topFreeApps):
                guard let topFreeApps else { return }
                group1 = topFreeApps
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        dispatchGroup.enter()
        NetworkManager.shared.fetchTopPaidsAppsForRows { results in
            dispatchGroup.leave()
            switch results {
            case .success(let topPaidsApps):
                guard let topPaidsApps else { return }
                group2 = topPaidsApps
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        dispatchGroup.enter()
        NetworkManager.shared.fetchHeaderSocialApps { results in
            dispatchGroup.leave()
            switch results {
            case .success(let headerApps):
                group3 = headerApps
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.indicatorView.stopAnimating()
            if let group = group1 { self.groups.append(group) }
            if let group = group2 { self.groups.append(group) }
            if let headerGroup = group3 { self.headerApps.append(contentsOf: headerGroup) }
            self.collectionView.reloadData()
        }
    }
}

extension AppsMainCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsGroupCollectionViewCell.identifier, for: indexPath) as! AppsGroupCollectionViewCell
        let appGroup = groups[indexPath.item]
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalCollectionViewController.horizontalTopFreeApps = appGroup
        cell.horizontalCollectionViewController.collectionView.reloadData()
        cell.horizontalCollectionViewController.didSelectHandler = { [weak self] selectedApp in
            let detailViewController = AppDetailCollectionViewController()
            detailViewController.navigationItem.title = selectedApp.name
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }
        return cell
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension AppsMainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: AppsHeaderReusableView.identifier,
            for: indexPath
        ) as! AppsHeaderReusableView
        header.headerHorizontalReusableController.headerApps = headerApps
        header.headerHorizontalReusableController.collectionView.reloadData()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width, height: 300)
    }
}

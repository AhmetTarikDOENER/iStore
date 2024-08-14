import SwiftUI

final class CompositionalCollectionViewController: UICollectionViewController {
    
    var apps = [HeaderApps]()
    var topFreeApps: AppRowResults?
    var topPaidApps: AppRowResults?
    
    var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable>!
    
    init() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                return CompositionalCollectionViewController.createSectionForTopThreeApps()
            } else {
                return CompositionalCollectionViewController.createSectionForBottomMultipleApps()
            }
        }
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        prepareCollectionView()
        configureDiffableDataSource()
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "Apps"
        navigationItem.largeTitleDisplayMode = .inline
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = .init(title: "Fetch Free Books", style: .plain, target: self, action: #selector(didTapFetchTopPaid))
    }
    
    @objc private func didTapFetchTopPaid() {
        navigationItem.rightBarButtonItem = nil
        NetworkManager.shared.fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/us/books/top-free/25/books.json") { result in
            switch result {
            case .success(let books):
                var snapshot = self.diffableDataSource.snapshot()
                snapshot.insertSections([.topBooks], afterSection: .header)
                snapshot.appendItems(books?.feed.results ?? [], toSection: .topBooks)
                self.diffableDataSource.apply(snapshot)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func prepareCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CompositionalHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CompositionalHeaderReusableView.identifier)
        collectionView.register(AppsHeaderReusableCollectionViewCell.self, forCellWithReuseIdentifier: AppsHeaderReusableCollectionViewCell.identifier)
        collectionView.register(AppRowCollectionViewCell.self, forCellWithReuseIdentifier: AppRowCollectionViewCell.identifier)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didDragForRefreshing), for: .valueChanged)
    }
    
    @objc private func didDragForRefreshing() {
        collectionView.refreshControl?.endRefreshing()
        var snapshot = diffableDataSource.snapshot()
        snapshot.deleteSections([.topBooks])
        diffableDataSource.apply(snapshot)
    }
    
    enum AppSection {
        case header
        case topFrees
        case topPaids
        case topBooks
    }
    
    lazy var snapshot = diffableDataSource.snapshot()
    
    private func fetchApps() {
        NetworkManager.shared.fetchHeaderSocialApps { result in
            switch result {
            case .success(let headerApp):
                self.snapshot.appendSections([.header])
                self.snapshot.appendItems(headerApp ?? [])
                self.diffableDataSource?.apply(self.snapshot)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        NetworkManager.shared.fetchTopFreeAppsForRows { result in
            switch result {
            case .success(let topFreeApps):
                self.snapshot.appendSections([.topFrees])
                self.snapshot.appendItems(topFreeApps?.feed.results ?? [])
                self.diffableDataSource?.apply(self.snapshot)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        NetworkManager.shared.fetchTopPaidsAppsForRows { result in
            switch result {
            case .success(let topPaidsApps):
                self.snapshot.appendSections([.topPaids])
                self.snapshot.appendItems(topPaidsApps?.feed.results ?? [])
                self.diffableDataSource?.apply(self.snapshot)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureDiffableDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<AppSection, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, object -> UICollectionViewCell? in
            if let object = object as? HeaderApps {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsHeaderReusableCollectionViewCell.identifier, for: indexPath) as! AppsHeaderReusableCollectionViewCell
                cell.headerApp = object
                return cell
            } else if let object = object as? FeedResult {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppRowCollectionViewCell.identifier, for: indexPath) as! AppRowCollectionViewCell
                cell.app = object
                cell.getButton.addTarget(self, action: #selector(self.didTapGetButton), for: .primaryActionTriggered)
                return cell
            }
            return nil
        }
        diffableDataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath -> UICollectionReusableView? in
            let header = self.collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: CompositionalHeaderReusableView.identifier, for: indexPath) as! CompositionalHeaderReusableView
            let snapshot = self.diffableDataSource.snapshot()
            let item = self.diffableDataSource.itemIdentifier(for: indexPath)
            let section = snapshot.sectionIdentifier(containingItem: item ?? nil)
            if section == .topFrees {
                header.sectionHeaderLabel.text = "Top Free Apps"
            } else if section == .topPaids {
                header.sectionHeaderLabel.text = "Top Paid Apps"
            } else {
                header.sectionHeaderLabel.text = "Top Free Books"
            }
            return header
        }
        fetchApps()
    }

    private static func createSectionForTopThreeApps() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 16)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(275))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
        
        return section
    }
    
    /// This event triggers the deletion of the selected app.
    @objc private func didTapGetButton(button: UIButton) {
        var superview = button.superview
        while superview != nil {
            if let cell = superview as? UICollectionViewCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                guard let selectedApp = diffableDataSource.itemIdentifier(for: indexPath) else { return }
                var snapshot = diffableDataSource.snapshot()
                snapshot.deleteItems([selectedApp])
                diffableDataSource.apply(snapshot)
            }
            superview = superview?.superview
        }
    }
    
    private static func createSectionForBottomMultipleApps() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
        section.boundarySupplementaryItems = [
            .init(
                layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
        ]
        
        return section
    }
}

extension CompositionalCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = diffableDataSource.itemIdentifier(for: indexPath)
        if let item = item as? HeaderApps {
            let detailViewController = AppDetailCollectionViewController(id: item.id)
            navigationController?.pushViewController(detailViewController, animated: true)
        } else if let item = item as? FeedResult {
            let detailViewController = AppDetailCollectionViewController(id: item.id)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

struct AppsView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let navController = UINavigationController(rootViewController: CompositionalCollectionViewController())
        
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

struct AppCompositionalView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    AppsView()
        .ignoresSafeArea(.all)
}

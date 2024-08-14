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
        navigationItem.title = "Apps"
        navigationItem.largeTitleDisplayMode = .inline
        navigationController?.navigationBar.prefersLargeTitles = true
        prepareCollectionView()
        configureDiffableDataSource()
    }
    
    fileprivate func prepareCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CompositionalHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CompositionalHeaderReusableView.identifier)
        collectionView.register(AppsHeaderReusableCollectionViewCell.self, forCellWithReuseIdentifier: AppsHeaderReusableCollectionViewCell.identifier)
        collectionView.register(AppRowCollectionViewCell.self, forCellWithReuseIdentifier: AppRowCollectionViewCell.identifier)
    }
    
    enum AppSection {
        case header
        case topFrees
        case topPaids
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
            } else {
                header.sectionHeaderLabel.text = "Top Paid Apps"
            }
            return header
        }
        var snapshot = diffableDataSource.snapshot()
        NetworkManager.shared.fetchHeaderSocialApps { result in
            switch result {
            case .success(let headerApp):
                snapshot.appendSections([.header])
                snapshot.appendItems(headerApp ?? [])
                self.diffableDataSource?.apply(snapshot)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        NetworkManager.shared.fetchTopFreeAppsForRows { result in
            switch result {
            case .success(let topFreeApps):
                snapshot.appendSections([.topFrees])
                snapshot.appendItems(topFreeApps?.feed.results ?? [])
                self.diffableDataSource?.apply(snapshot)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        NetworkManager.shared.fetchTopPaidsAppsForRows { result in
            switch result {
            case .success(let topPaidsApps):
                snapshot.appendSections([.topPaids])
                snapshot.appendItems(topPaidsApps?.feed.results ?? [])
                self.diffableDataSource?.apply(snapshot)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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

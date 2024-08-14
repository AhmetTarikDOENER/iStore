import SwiftUI

final class CompositionalCollectionViewController: UICollectionViewController {
    
    var apps = [HeaderApps]()
    var topFreeApps: AppRowResults?
    var topPaidApps: AppRowResults?
    
    var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, HeaderApps>!
    
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
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, headerApp -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsHeaderReusableCollectionViewCell.identifier, for: indexPath) as! AppsHeaderReusableCollectionViewCell
            cell.headerApp = headerApp
            return cell
        }
        NetworkManager.shared.fetchHeaderSocialApps { headerApps in
            switch headerApps {
            case .success(let headerApp):
                var snapshot = NSDiffableDataSourceSnapshot<AppSection, HeaderApps>()
                snapshot.appendSections([.header])
                snapshot.appendItems(headerApp ?? [])
                self.diffableDataSource.apply(snapshot)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
//    
//    private func fetchApps() {
//        let dispatchGroup = DispatchGroup()
//        var headerGroup: [HeaderApps]?
//        var topFreeAppGroup: AppRowResults?
//        var topPaidAppGroup: AppRowResults?
//        dispatchGroup.enter()
//        NetworkManager.shared.fetchHeaderSocialApps { results in
//            switch results {
//            case .success(let apps):
//                headerGroup = apps
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//            dispatchGroup.leave()
//        }
//        dispatchGroup.enter()
//        NetworkManager.shared.fetchTopFreeAppsForRows { results in
//            switch results {
//            case .success(let topFreeApps):
//                topFreeAppGroup = topFreeApps
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//            dispatchGroup.leave()
//        }
//        dispatchGroup.enter()
//        NetworkManager.shared.fetchTopPaidsAppsForRows { results in
//            switch results {
//            case .success(let topPaidApps):
//                topPaidAppGroup = topPaidApps
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//            dispatchGroup.leave()
//        }
//        dispatchGroup.notify(queue: .main) {
//            if let header = headerGroup { self.apps.append(contentsOf: header) }
//            if let freeApps = topFreeAppGroup { self.topFreeApps = freeApps }
//            if let paidApps = topPaidAppGroup { self.topPaidApps = paidApps }
//            self.collectionView.reloadData()
//        }
//    }
    
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        0
    }
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            apps.count
//        } else if section == 1 {
//            topFreeApps?.feed.results.count ?? 0
//        } else {
//            topPaidApps?.feed.results.count ?? 0
//        }
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CompositionalHeaderReusableView.identifier, for: indexPath) as! CompositionalHeaderReusableView
//        var title: String?
//        if indexPath.section == 1 {
//            title = topFreeApps?.feed.title
//        } else if indexPath.section == 2 {
//            title = topPaidApps?.feed.title
//        }
//        header.sectionHeaderLabel.text = title
//        return header
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.section {
//        case 0:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsHeaderReusableCollectionViewCell.identifier, for: indexPath) as! AppsHeaderReusableCollectionViewCell
//            cell.companyNameLabel.text = apps[indexPath.item].name
//            cell.titleLabel.text = apps[indexPath.item].tagline
//            cell.imageView.sd_setImage(with: URL(string: apps[indexPath.item].imageUrl))
//            
//            return cell
//        case 1:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppRowCollectionViewCell.identifier, for: indexPath) as! AppRowCollectionViewCell
//            cell.nameLabel.text = topFreeApps?.feed.results[indexPath.item].name
//            cell.companyNameLabel.text = topFreeApps?.feed.results[indexPath.item].artistName
//            cell.iconImageView.sd_setImage(with: URL(string: topFreeApps?.feed.results[indexPath.item].artworkUrl100 ?? ""))
//
//            return cell
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppRowCollectionViewCell.identifier, for: indexPath) as! AppRowCollectionViewCell
//            cell.nameLabel.text = topPaidApps?.feed.results[indexPath.item].name
//            cell.companyNameLabel.text = topPaidApps?.feed.results[indexPath.item].artistName
//            cell.iconImageView.sd_setImage(with: URL(string: topPaidApps?.feed.results[indexPath.item].artworkUrl100 ?? ""))
//            return cell
//        }
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let appID: String
//        if indexPath.section == 0 {
//            appID = apps[indexPath.item].id
//            
//        } else if indexPath.section == 1 {
//            appID = topFreeApps?.feed.results[indexPath.item].id ?? ""
//        } else {
//            appID = topPaidApps?.feed.results[indexPath.item].id ?? ""
//        }
//        let appDetailViewController = AppDetailCollectionViewController(id: appID)
//        navigationController?.pushViewController(appDetailViewController, animated: true)
//    }
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

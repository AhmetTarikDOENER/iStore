import SwiftUI

final class CompositionalCollectionViewController: UICollectionViewController {
    
    var apps = [HeaderApps]()
    
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
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CompositionalHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CompositionalHeaderReusableView.identifier)
        collectionView.register(AppsHeaderReusableCollectionViewCell.self, forCellWithReuseIdentifier: AppsHeaderReusableCollectionViewCell.identifier)
        collectionView.register(AppRowCollectionViewCell.self, forCellWithReuseIdentifier: AppRowCollectionViewCell.identifier)
        fetchApps()
    }
    
    private func fetchApps() {
        NetworkManager.shared.fetchHeaderSocialApps { results in
            switch results {
            case .success(let apps):
                DispatchQueue.main.async {
                    self.apps = apps ?? []
                    self.collectionView.reloadData()
                }
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        apps.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CompositionalHeaderReusableView.identifier, for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsHeaderReusableCollectionViewCell.identifier, for: indexPath) as! AppsHeaderReusableCollectionViewCell
            cell.companyNameLabel.text = apps[indexPath.item].name
            cell.titleLabel.text = apps[indexPath.item].tagline
            cell.imageView.sd_setImage(with: URL(string: apps[indexPath.item].imageUrl))
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppRowCollectionViewCell.identifier, for: indexPath) as! AppRowCollectionViewCell
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let id = apps[indexPath.item].id
            let appDetailViewController = AppDetailCollectionViewController(id: id)
            navigationController?.pushViewController(appDetailViewController, animated: true)
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

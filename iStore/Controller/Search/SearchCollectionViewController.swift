import UIKit
import SDWebImage

final class SearchCollectionViewController: RootListCollectionViewController {
    
    private var apps = [AppSearch]()
    private var timer: Timer?
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let enterSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "No results..\nPlease enter a search term above."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureSearchBar()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
        collectionView.addSubview(enterSearchLabel)
        NSLayoutConstraint.activate([
            enterSearchLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 20),
            enterSearchLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
    }
    
    private func configureSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.delegate = self
    }
}
//  MARK: - UICollectionViewDataSource:
extension SearchCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchLabel.isHidden = apps.count != 0
        return apps.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath) as! SearchResultsCollectionViewCell
        cell.appResult = apps[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appDetailController = AppDetailCollectionViewController()
        let id = apps[indexPath.item].trackId
        appDetailController.id = String(id)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}
//  MARK: - UICollectionViewDelegateFlowLayout:
extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 300)
    }
}
//  MARK: - UISearchBarDelegate:
extension SearchCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            NetworkManager.shared.fetchApps(searchTerm: searchText) { results in
                switch results {
                case .success(let apps):
                    DispatchQueue.main.async {
                        self.apps = apps.results
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
}

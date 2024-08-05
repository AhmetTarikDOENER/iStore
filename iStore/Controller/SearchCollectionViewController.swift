import UIKit
import SDWebImage

final class SearchCollectionViewController: UICollectionViewController {
    
    private var apps = [App]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
        configureSearchBar()
        fetchApps()
    }
    
    private func configureSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.delegate = self
    }

    private func fetchApps() {
        NetworkManager.shared.fetchApps(searchTerm: "Facebook") { results in
            switch results {
            case .success(let apps):
                DispatchQueue.main.async {
                    self.apps = apps
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                ()
            }
        }
    }
}
//  MARK: - UICollectionViewDataSource:
extension SearchCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        apps.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath) as! SearchResultsCollectionViewCell
        cell.appResult = apps[indexPath.item]

        return cell
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
        
    }
}

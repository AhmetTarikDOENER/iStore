import UIKit
import SDWebImage

final class SearchCollectionViewController: UICollectionViewController {
    
    private var apps = [App]()
    private var timer: Timer?
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let enterSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter a search term above.."
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureSearchBar()
    }
    
    fileprivate func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
        collectionView.addSubview(enterSearchLabel)
        enterSearchLabel.fillSuperView(.init(top: 10, left: 20, bottom: 0, right: 0))
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
        enterSearchLabel.isHidden = apps.count != 0
        return apps.count
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
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            NetworkManager.shared.fetchApps(searchTerm: searchText) { results in
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
}

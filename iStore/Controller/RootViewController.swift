import UIKit

final class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
    }
    
    private func createNavigationController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        viewController.navigationItem.title = title
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.view.backgroundColor = .systemBackground
        navigationController.tabBarItem = .init(title: title, image: UIImage(named: imageName), selectedImage: nil)
        navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
    
    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        viewControllers = [
            createNavigationController(viewController: TodayCollectionViewController(), title: "Today", imageName: "today_icon"),
            createNavigationController(viewController: AppsMainCollectionViewController(), title: "Apps", imageName: "apps"),
            createNavigationController(
                viewController: SearchCollectionViewController(),
                title: "Search",
                imageName: "search"
            ),
        ]
    }
}

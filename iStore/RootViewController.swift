import UIKit

final class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewControllers = [
            createNavigationController(viewController: UIViewController(), title: "Today", imageName: "today_icon"),
            createNavigationController(viewController: UIViewController(), title: "Apps", imageName: "apps"),
            createNavigationController(viewController: UIViewController(), title: "Search", imageName: "search")
        ]
    }
    
    private func createNavigationController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        viewController.navigationItem.title = title
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.view.backgroundColor = .systemBackground
        navigationController.tabBarItem = .init(title: title, image: UIImage(named: imageName), selectedImage: nil)
        navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
}

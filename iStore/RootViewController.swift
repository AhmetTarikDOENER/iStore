import UIKit

final class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let redVC = UIViewController()
        redVC.view.backgroundColor = .systemBackground
        redVC.navigationItem.title = "Apps"
        let redNavVC = UINavigationController(rootViewController: redVC)
        redNavVC.navigationBar.prefersLargeTitles = true
        redNavVC.tabBarItem = .init(title: "Apps", image: UIImage(named: "apps"), selectedImage: nil)
        
        let blueVC = UIViewController()
        blueVC.view.backgroundColor = .systemBackground
        blueVC.navigationItem.title = "Search"
        let blueNavVC = UINavigationController(rootViewController: blueVC)
        blueNavVC.navigationBar.prefersLargeTitles = true
        blueVC.tabBarItem = .init(title: "Search", image: UIImage(named: "search"), selectedImage: nil)
        
        viewControllers = [
            redNavVC,
            blueNavVC,
        ]
    }
}

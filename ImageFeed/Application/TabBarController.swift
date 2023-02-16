import UIKit

final class TabBarController: UITabBarController {
    
    private struct Constants {
        static let storyboardName = "Main"
        static let imageListVCIdentifier = "ImagesListViewController"
        static let profileTabbarItemTitle = "Profile"
        static let profileTabbarItemIcon = "ProfileIcon"
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: Constants.imageListVCIdentifier)
        let profileViewController = ProfileViewController()
        
        profileViewController.tabBarItem = UITabBarItem(title: Constants.profileTabbarItemTitle, image: UIImage(named: Constants.profileTabbarItemIcon), selectedImage: nil)
        
        viewControllers = [imageListViewController, profileViewController]
    }
}

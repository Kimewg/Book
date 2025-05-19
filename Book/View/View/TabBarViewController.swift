import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    private func setupViewControllers() {
        let searchVC = SearchViewController()
        let nav1 = UINavigationController(rootViewController: searchVC)
        searchVC.tabBarItem = UITabBarItem(title: "검색 탭", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let listVC = ListViewController()
        let nav2 = UINavigationController(rootViewController: listVC)
        listVC.tabBarItem = UITabBarItem(title: "담은 책 리스트 탭", image: UIImage(systemName: "book"), tag: 1)
        
        viewControllers = [nav1, nav2]
    }
    
    private func setupTabBarAppearance() {
        tabBar.unselectedItemTintColor = .gray // 선택 안된 탭 아이템 색상
        tabBar.tintColor = .red // 선택된 탭 아이템 색상
        tabBar.isTranslucent = true
    }
}


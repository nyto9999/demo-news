import Foundation
import UIKit

class TabBarController:UITabBarController, UITabBarControllerDelegate {
    
  //MARK: Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
    _setupViews()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  //MARK: UI
  private func _setupViews() {
    delegate = self
    self.viewControllers = _tabItemsFactory()
    selectedIndex = 1
  }
  
  //MARK: Methods
  private func _tabItemsFactory() -> [UIViewController] {
    let views = [
      UINavigationController(rootViewController: SearchView()),
      UINavigationController(rootViewController: NewsView()),
      UINavigationController(rootViewController: CountryListView())
    ]
    
    let icons = [
      UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle.fill"), tag: 0),
      UITabBarItem(title: "Headlines", image: UIImage(systemName: "flame.circle.fill"), tag: 1),
      UITabBarItem(title: "Country", image: UIImage(systemName: "gearshape.circle.fill"), tag: 2),
    ]
    
    for (index, view) in views.enumerated() {
      view.tabBarItem = icons[index]
    }
    return views
  }
}

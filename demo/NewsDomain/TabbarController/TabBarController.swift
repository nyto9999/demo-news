import Foundation
import UIKit

class TabBarController:UITabBarController, UITabBarControllerDelegate {
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    _setupViews()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  private func _setupViews() {
    delegate = self
    self.viewControllers = _tabItemsFactory()
    selectedIndex = 0
  }
  
  private func _tabItemsFactory() -> [UIViewController] {
    
    let views = [
      NewsView(),
      CountryListView()
    ]
    
    let icons = [
      UITabBarItem(title: "Headlines", image: UIImage(systemName: "flame.circle.fill"), tag: 1),
      UITabBarItem(title: "Country", image: UIImage(systemName: "gearshape.circle.fill"), tag: 2),
      
    ]
    
    for (index, view) in views.enumerated() {
      view.tabBarItem = icons[index]
    }
    
    return views
  }
}

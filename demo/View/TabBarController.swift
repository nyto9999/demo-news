import Foundation
import UIKit
import SwiftUI

class TabBarController:UITabBarController, UITabBarControllerDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.viewControllers = tabItemsFactory()
    selectedIndex = 0
  }
  
  private func tabItemsFactory() -> [UIViewController] {
    let views = [
      HeadlinesView(),
      RegionView(),
    ]
    let icons = [
      UITabBarItem(title: "Headlines", image: UIImage(systemName: "flame.circle.fill"), tag: 0),
      UITabBarItem(title: "Region", image: UIImage(systemName: "gearshape.circle.fill"), tag: 1),
    ]
    
    for (index, view) in views.enumerated() {
      view.tabBarItem = icons[index]
    }
    
    return views
  }
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    print("Should select viewController: \(viewController.tabBarItem.tag) ?")
    return true
  }
  
  
}

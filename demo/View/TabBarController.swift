import Foundation
import UIKit
import SwiftUI

class TabBarController: UITabBarController, UITabBarControllerDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.viewControllers = tabItemsFactory()
  }
  
  private func tabItemsFactory() -> [UIViewController] {
    let views = [
      NewsView(),
      NewsView(),
      NewsView(),
    ]
    let icons = [
      UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 1),
      UITabBarItem(title: "Headlines", image: UIImage(systemName: "flame.circle.fill"), tag: 2),
      UITabBarItem(title: "Country", image: UIImage(systemName: "flag.badge.ellipsis"), tag: 3),
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

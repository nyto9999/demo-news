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
    self.viewControllers = _tabItemsFactory()
    selectedIndex = 0
  }
  
  private func _tabItemsFactory() -> [UIViewController] {
    let views = [
      NewsView(),
      CountryListView(),
    ]
    let icons = [
      UITabBarItem(title: "Headlines", image: UIImage(systemName: "flame.circle.fill"), tag: 0),
      UITabBarItem(title: "Country", image: UIImage(systemName: "gearshape.circle.fill"), tag: 1),
    ]
    
    for (index, view) in views.enumerated() {
      view.tabBarItem = icons[index]
    }
    
    return views
  }
  
//  private func _getCountryList() -> [String] {
//    var array = [String]()
//    for country in Constants.isoCountryCode.allCases {
//      array.append(country.rawValue)
//    }
//    return array
//  }
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    print("Should select viewController: \(viewController.tabBarItem.tag) ?")
    return true
  }
  

  
  
}

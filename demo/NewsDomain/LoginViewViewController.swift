import UIKit
import SwiftUI

class LoginViewViewController: UIViewController {
  
  //layouts
  lazy var loginButton:UIButton = {
    
    //action
    let action = UIAction(title: "Login") { (action) in
      let vc = TabBarController()
      let nav = UINavigationController(rootViewController: vc)
      nav.modalPresentationStyle = .overCurrentContext
      self.present(nav, animated: true, completion: nil)
    }
    
    //
    let button = UIButton(frame: CGRect(x: (view.frame.width - 100) / 2.0, y: (view.frame.height - 50) / 2.0 + 50, width: 100, height: 50))
    button.setTitle("Login", for: .normal)
    button.backgroundColor = .blue
    button.addAction(action, for: .touchUpInside)
    return button
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(loginButton)
  }
}

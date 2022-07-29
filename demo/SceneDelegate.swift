import UIKit
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
    
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    BGTaskScheduler.shared.register(
      forTaskWithIdentifier: Constants.backgroundTaskIdentifier,
      using: nil)
      { (task) in
        
        task.expirationHandler = {
          print("failed")
        }
        
        
        task.setTaskCompleted(success: true)
      }
    
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
    window?.makeKeyAndVisible()
    let vc = LoginViewViewController()
    window?.rootViewController = UINavigationController(rootViewController: vc)
    
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    self.scheduleAppRefresh()
  }
  
  func scheduleAppRefresh() {
    
    let request = BGAppRefreshTaskRequest(identifier: Constants.backgroundTaskIdentifier)
    
    //dont start refreshing my app untill atleat 1 hour when I schedule it
    request.earliestBeginDate = Date(timeIntervalSinceNow: 3)
    do {
      print("hi")
      try BGTaskScheduler.shared.submit(request)
    }
    catch {
      print("Could not schedule app refresh \(error)")
    }
  }
  
  
}


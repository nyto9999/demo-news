import UIKit
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
    
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    // MARK: Background Tasks
    BGTaskScheduler.shared.register(
      forTaskWithIdentifier: Constants.backgroundTaskIdentifier,
      using: nil)
      { (task) in
        print("tasking")
        task.expirationHandler = {
          print("failed")
        }

        print("prefetching in bg...")

        Task {
          try await NewsClient().receiveData(type:.backup)
        }
        task.setTaskCompleted(success: true)
      }
    
    // MARK: Windows
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
    window?.makeKeyAndVisible()
    let vc = LoginViewViewController()
    window?.rootViewController = vc
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
  // MARK: Schedule Background Tasks in sceneDidEnterBackground
  func scheduleAppRefresh() {
    
    let request = BGAppRefreshTaskRequest(identifier: Constants.backgroundTaskIdentifier)
    
    //dont start refreshing my app untill atleat 1 hour when I schedule it
//    request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60)
    request.earliestBeginDate = Date(timeIntervalSinceNow: 5)
    do {
      print("scheduling...")
      try BGTaskScheduler.shared.submit(request)
    }
    catch {
      print("Could not schedule app refresh \(error)")
    }
  }
  
  
}


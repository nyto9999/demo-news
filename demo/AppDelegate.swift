import UIKit
import BackgroundTasks
import CoreData
import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var cancellable = Set<AnyCancellable>()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    print("appdelegate")
    BGTaskScheduler.shared.register(
      forTaskWithIdentifier: AppConstants.backgroundTaskIdentifier,
      //nil is background thread
      using: nil)
      { (task) in
        let c = SceneDelegate()
        c.scheduleAppRefresh()
        
        let vm = NewsViewModel()
        let data = vm.newsEverything()
        
        data.sink { result in
          switch result {
            case .finished:
              print("finished")
              task.setTaskCompleted(success: true)
            case .failure(let error):
              task.expirationHandler = {
                print(error)
              }
          }
          
        } receiveValue: { news in
          print(news.count)
        }
        .store(in: &self.cancellable)
        task.setTaskCompleted(success: true)
      }
    return true
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    
  }
  
  
  
  func handleAppRefresh(task: BGAppRefreshTask) {
    
  }
  

  

  // MARK: UISceneSession Lifecycle
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
}


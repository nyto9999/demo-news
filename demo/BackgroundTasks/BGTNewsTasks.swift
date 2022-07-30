import UIKit
import Combine
import Resolver

protocol BGTasksProtocol {
  func downloadHeadlines()
}

final class BGNewsTasks: APIClient, BGTasksProtocol {
  
  @Injected internal var session: URLSession
  
  func downloadHeadlines() {
    Task.detached(priority: .medium) {
      let request = NewsProvider.getTopheadlines.reuqest
      
      try await self.jsonDownloader(with: request, type: Constants.NewsType.headlines.rawValue)
    }
  }
}

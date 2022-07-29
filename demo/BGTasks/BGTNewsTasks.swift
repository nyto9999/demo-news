import UIKit
import Combine
import Resolver

protocol BGTasksProtocol {
  func downloadHeadlines()
}

final class BGNewsTasks: APIClient, BGTasksProtocol {
  
  @Injected internal var session: URLSession
  
  func downloadHeadlines() {
    let request = NewsProvider.getTopheadlines.reuqest
    return jsonDownloader(with: request, type: Constants.NewsType.headlines.rawValue)
  }
}

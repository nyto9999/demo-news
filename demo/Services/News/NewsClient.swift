import UIKit
import Combine

final class NewsClient: APIClient, NewsClientProtocol {
  
  var session: URLSession
  
  //MARK: Initializers
  init(configuration: URLSessionConfiguration) {
    self.session = URLSession(configuration: configuration)
  }
  
  convenience init() {
    let configuration: URLSessionConfiguration = .default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    self.init(configuration: configuration)
  }
  
  
  // MARK: News List
  func getTopheadlines() -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.getTopheadlines.reuqest
    return fetch(with: request, decodeType: NewsResult())
  }
  
  func getEverything() -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.getEverything.reuqest
    return fetch(with: request, decodeType: NewsResult())
  }
}

enum APIError: Error {
  case decodingFailed(error: Swift.DecodingError)
  case networkFailed(error: URLError, url: URL)
  case unknown
}



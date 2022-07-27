import UIKit
import Combine
import Resolver

final class NewsClient: APIClient, NewsClientProtocol {
   
  @Injected internal var session: URLSession
  
  // MARK: News List
  func getTopheadlines() -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.getTopheadlines.reuqest
    return fetch(with: request, decodeType: NewsResult())
  }
  
  func getEverything() -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.getEverything.reuqest
    return fetch(with: request, decodeType: NewsResult())
  }
  
  func search(searchText: String) -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.search(searchText: searchText).reuqest
    return fetch(with: request, decodeType: NewsResult())
  }
  
}

enum APIError: Error {
   
  case decodingFailed(error: Swift.DecodingError)
  case networkFailed(error: URLError, url: URL)
  case unknown
}



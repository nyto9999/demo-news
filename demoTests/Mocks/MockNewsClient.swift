import Foundation
import Resolver
import Combine

class MockNewsClient:APIClient, NewsClientProtocol {
  
  var session: URLSession = URLSession(configuration: .default)
  
  func getTopheadlines() -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.getTopheadlines.reuqest
    return fetch(with: request, decodeType: NewsResult())
  }
  
  func getEverything() -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.getTopheadlines.reuqest
    return fetch(with: request, decodeType: NewsResult())
  }
  
  func search(searchText: String) -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.search(searchText: searchText).reuqest
    return fetch(with: request, decodeType: NewsResult())
  }
  
}

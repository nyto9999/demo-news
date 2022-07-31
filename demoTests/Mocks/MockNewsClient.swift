import Foundation
import Resolver
import Combine

class MockNewsClient: APIClient, MockProtocol {
  
  var session: URLSession = URLSession(configuration: .default)
  
  func publisherTopheadlines() -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.getTopheadlines.reuqest
    return fetchAndDecode(with: request, decodeType: NewsResult())
  }
  
  func publisherSearch(searchText: String) -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.search(searchText: searchText).reuqest
    return fetchAndDecode(with: request, decodeType: NewsResult())
  }
 
 
}


protocol MockProtocol {
 
  func publisherTopheadlines() -> AnyPublisher<NewsResult, APIError>
  
  func publisherSearch(searchText: String) -> AnyPublisher<NewsResult, APIError>
   
}


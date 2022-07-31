import Foundation
import Resolver
import Combine

class MockNewsClient: APIClient, MockProtocol {
  
  var session: URLSession = URLSession(configuration: .default)
  
  func publisherTopheadlines() -> AnyPublisher<NewsResult, MyError> {
    let request = NewsProvider.getTopheadlines.reuqest
    return fetchAndDecode(for: request, decodeType: NewsResult())
  }
  
  func publisherSearch(searchText: String) -> AnyPublisher<NewsResult, MyError> {
    let request = NewsProvider.search(searchText: searchText).reuqest
    return fetchAndDecode(for: request, decodeType: NewsResult())
  }
 
 
}


protocol MockProtocol {
 
  func publisherTopheadlines() -> AnyPublisher<NewsResult, MyError>
  
  func publisherSearch(searchText: String) -> AnyPublisher<NewsResult, MyError>
   
}


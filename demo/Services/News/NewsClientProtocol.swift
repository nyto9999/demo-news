import Foundation

import Combine
protocol NewsClientProtocol {
  
  func getTopheadlines() -> AnyPublisher<NewsResult, APIError>
  
  func getEverything() -> AnyPublisher<NewsResult, APIError>
  
  func search(searchText: String) -> AnyPublisher<NewsResult, APIError>
}

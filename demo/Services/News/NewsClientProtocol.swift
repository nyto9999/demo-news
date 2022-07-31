import Foundation
import Combine

protocol NewsClientProtocol {
  
  func getTopheadlines() -> AnyPublisher<NewsResult, APIError>
  
  func search(searchText: String) -> AnyPublisher<NewsResult, APIError>
  
  func fetchAndSave() async throws
}

import Foundation
import Combine

protocol NewsClientProtocol {
  
  func getTopheadlines() -> AnyPublisher<NewsResult, MyError>
  
  func search(searchText: String) -> AnyPublisher<NewsResult, MyError>
  
  func fetchAndSave() async throws
}

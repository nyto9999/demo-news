import Foundation
import Combine

protocol NewsClientProtocol {
  
  //publisher way
  func getTopheadlines() -> AnyPublisher<NewsResult, APIError>
  
  func search(searchText: String) -> AnyPublisher<NewsResult, APIError>
  
  // async way
  //  func getTopheadlines() async throws -> NewsResult
  //
  //  func search(searchText: String) async throws -> NewsResult
}

import Foundation
import Combine

protocol NewsViewModelProtocol {
  //publisher way
  typealias newsPublisher = AnyPublisher<[News], APIError>
  func newsTopHeadlines() -> newsPublisher
  func search(searchText: String) -> newsPublisher
  
  //async way
//  func newsTopHeadlines() async throws -> [News]
//  func search(searchText: String) async throws
}

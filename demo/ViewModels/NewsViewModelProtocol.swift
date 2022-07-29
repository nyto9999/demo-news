import Foundation
import Combine

protocol NewsViewModelProtocol {
  typealias newsPublisher = AnyPublisher<[News], APIError>
  
  // news topheadlines list
  func newsTopHeadlines() -> newsPublisher
  
  //search list
  func search(searchText: String) -> newsPublisher
}

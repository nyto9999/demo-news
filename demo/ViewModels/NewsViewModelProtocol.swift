import Foundation
import Combine

protocol NewsViewModelProtocol {
  typealias newsPublisher = AnyPublisher<[News], APIError>
  
  // news topheadlines list
  func newsTopHeadlines() -> newsPublisher
  
  
  // news everything list
  func newsEverything() -> newsPublisher
  
  //search list
  func search(searchText: String) -> newsPublisher
}

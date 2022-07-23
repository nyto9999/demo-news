import Foundation
import Combine

protocol NewsViewModelProtocol {
  typealias newsPublisher = AnyPublisher<[News], APIError>
  
  // news topheadlines list
  func newsTopHeadlines(isAscending: Bool) -> newsPublisher
  
  
  // news everything list
  func newsEverything(isAscending: Bool) -> newsPublisher
  
  //search list
  func search(searchText: String, isAscending: Bool) -> newsPublisher
}

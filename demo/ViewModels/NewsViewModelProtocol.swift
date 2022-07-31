import Foundation
import Combine

protocol NewsViewModelProtocol {
  //publisher way
  typealias newsPublisher = AnyPublisher<[News], MyError>
  func newsTopHeadlines() -> newsPublisher
  func search(searchText: String) -> newsPublisher
}

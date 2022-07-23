import Foundation

import Combine
protocol NewsClientProtocol {
  
  func getTopheadlines() -> AnyPublisher<NewsResult, APIError>
  
  func getEverything() -> AnyPublisher<NewsResult, APIError>
}

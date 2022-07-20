import UIKit
import Combine

protocol NetworkProtocol {
  func request() -> AnyPublisher<Data, GenericError>
}

class Network: NetworkProtocol {
  
  var url: URL
  
  //MARK: - Initializers
  init(keyword: [String:String]) {
    self.url = NewsUrl().path(keywords: keyword)!
  }
  convenience init() {
    self.init(keyword: [:])
  }
  
  //MARK: - NetworkProtocol
  func request() -> AnyPublisher<Data, GenericError> {
    return createDataTaskPublisher(from: url)
  }
  
  private func createDataTaskPublisher(from url: URL) -> AnyPublisher<Data,GenericError> {
    
    URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { data, response -> Data in
        guard let httpResponse = response as? HTTPURLResponse else { throw GenericError.networkFailed }
           let statusCode = httpResponse.statusCode
           guard (200..<300).contains(statusCode) else { throw GenericError.networkFailed }
           return data
       }
      .mapError { _ in GenericError.networkFailed }
       .eraseToAnyPublisher()
  }
}

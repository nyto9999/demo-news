import UIKit
import Combine

protocol NewsProtocol {
  func decodeData(from Network: AnyPublisher<Data, GenericError>) -> AnyPublisher<News, GenericError>
}

class NewsPublisher: NewsProtocol {
  private var network: Network
  
  //MARK: Initializers
  init() {
    self.network = Network()
  }
  
    
  //MARK: News Protocol
  func decodeData(from Network: AnyPublisher<Data, GenericError>) -> AnyPublisher<News, GenericError> {
    return network.request()
      .eraseToAnyPublisher()
    
      .decode(type: News.self, decoder: JSONDecoder())
      .mapError { error -> GenericError in
        switch error {
          case is Swift.DecodingError:
            return .decodingFailed
          default:
            return .networkFailed
        }
      }
      .eraseToAnyPublisher()
  }
}

enum GenericError: Error {
  case decodingFailed
  case networkFailed
}



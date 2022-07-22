import UIKit
import Combine

protocol NewsProtocol {
  var fetchNews:AnyPublisher<NewsResult, NetworkError> { get }
}

final class NewsPublisher {
  private var url:URL
  
  //MARK: Initializers
  init(keyword: [String:String], type: pathType) {
    self.url = NewsUrl().path(keywords: keyword, type: type)!
  }
  convenience init() {
    self.init(keyword: [:], type: pathType.everything)
  }
  
  //MARK: News Protocol
  var fetchNews: AnyPublisher<NewsResult, NetworkError> {
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
           throw URLError(.badServerResponse)
        }
        return element.data
      }
      .decode(type: NewsResult.self, decoder: JSONDecoder())
      .mapError { error -> NetworkError in
        switch error {
          case let URLError as URLError:
            return .networkFailed(error: URLError, url: self.url)
          case let decode as Swift.DecodingError:
            return .decodingFailed(error: decode)
          default:
            return .unknown
        }
      }
      .eraseToAnyPublisher()
  }
}

enum NetworkError: Error {
  case decodingFailed(error: Swift.DecodingError)
  case networkFailed(error: URLError, url: URL)
  case unknown
}



import UIKit
import Combine

protocol NewsProtocol {
  var fetchNews:AnyPublisher<News, GenericError> { get }
}

final class NewsPublisher: NewsProtocol {
  private var url:URL
  
  //MARK: Initializers
  init(keyword: [String:String]) {
    self.url = NewsUrl().path(keywords: keyword)!
  }
  convenience init() {
    self.init(keyword: [:])
  }
  
  //MARK: News Protocol
  var fetchNews: AnyPublisher<News, GenericError> {
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
           throw URLError(.badServerResponse)
        }
        return element.data
      }
      .decode(type: News.self, decoder: JSONDecoder())
      .mapError { error -> GenericError in
        switch error {
          case is URLError:
            return .networkFailed
          case is Swift.DecodingError:
            return .decodingFailed
          default:
            return .unknown
        }
      }
      .eraseToAnyPublisher()
  }
}

enum GenericError: Error {
  case decodingFailed
  case networkFailed
  case unknown
}



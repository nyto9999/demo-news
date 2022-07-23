import Foundation
import Combine

protocol APIClient {
  var session: URLSession { get }
}

//MARK: Network request then decode
extension APIClient {
  
  func fetch<T: Decodable>(with request: URLRequest, decodeType: T) -> AnyPublisher<T, APIError> {
    
    return session.dataTaskPublisher(for: request)
      .tryMap { element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode  else {
           throw URLError(.badServerResponse)
        }
        return element.data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .mapError { error -> APIError in
        switch error {
          case let URLError as URLError:
            return .networkFailed(error: URLError, url: request.url!)
          case let decode as Swift.DecodingError:
            return .decodingFailed(error: decode)
          default:
            return .unknown
        }
      }
      .eraseToAnyPublisher()
  }
}

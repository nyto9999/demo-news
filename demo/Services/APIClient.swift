import Foundation
import Combine

protocol APIClient {
  var session: URLSession { get }
}

//MARK: Network request then decode
extension APIClient {
  
  func fetch(with request: URLRequest, decodeType: NewsResult) -> AnyPublisher<NewsResult, APIError> {
    
    return session.dataTaskPublisher(for: request)
      .tryMap { element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode  else {
           throw URLError(.badServerResponse)
        }
        return element.data
      }
      .decode(type: NewsResult.self, decoder: JSONDecoder())
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
  
  //  let employeesPublisher = companyPublisher
  //     .flatMap { response in
  //        response.employees.publisher.setFailureType(Error.self)
  //     }
  //     .flatMap { employee -> AnyPublisher<(Employee, UIImage), Error> in
  //
  //        let profileImageUrl = URL(string: employee.profileImages.large)!
  //
  //        return URLSession.shared.dataTaskPublisher(for url: profileImageUrl)
  //            .compactMap { UIImage(data: $0.data) }
  //            .mapError { $0 as Error }
  //
  //            .map { (employee, $0) } // "zip" here into a tuple
  //
  //            .eraseToAnyPublisher()
  //
  //     }
  //     .collect()
}

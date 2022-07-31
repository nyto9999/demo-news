import Foundation
import Combine
import SwiftUI

protocol APIClient {
  var session: URLSession { get }
}

//MARK: Network request then decode
extension APIClient {
  
  //MARK: publisher way
  func fetchAndDecode<T: Decodable>(with request: URLRequest, decodeType: T) -> AnyPublisher<T, APIError> {
    
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
  
  func fetchAndSave(with request: URLRequest) async throws {
    
    let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.httpNoResponse(url: request.url!) }
    let fileManager = FileManager()
    
    guard let file = fileManager.backupFilePath() else { return }
    
    if fileManager.fileExists(atPath: file.path) {
      print("exist")
      try FileManager.default.removeItem(at: file)
    }
    try data.write(to: file, options: [.atomic])
    print(file)
  }
}



import Foundation
import Combine
import SwiftUI

protocol APIClient {
  var session: URLSession { get }
}

//MARK: Network request then decode
extension APIClient {
  
  //MARK: publisher way
  func fetchAndDecode<T: Decodable>(for request: URLRequest, decodeType: T) -> AnyPublisher<T, MyError> {
    
    return session.dataTaskPublisher(for: request)
      .tryMap { element -> Data in
        guard (element.response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
        return element.data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .mapError { error -> MyError in
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
  
  func fetchAndSave(for request: URLRequest) async throws {
    
    //fetching
    let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
    
    //saving
    let fileManager = FileManager()
    guard let file = fileManager.backupFilePath() else { throw MyError.fileNil }
    if fileManager.fileExists(atPath: file.path) {
      print("exist")
      try FileManager.default.removeItem(at: file)
    }
    try data.write(to: file, options: [.atomic])
    print(file)
  }
}



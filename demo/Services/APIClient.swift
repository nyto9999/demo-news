import Foundation
import Combine
import SwiftUI

protocol APIClient {
  var session: URLSession { get }
}

extension APIClient {
  
  //MARK: Fetching NewsAPI & Decoding
  func fetchAndDecode(for request: URLRequest, decodeType: NewsResult) -> AnyPublisher<NewsResult, MyError> {
    
    return session.dataTaskPublisher(for: request)
      .tryMap { element -> Data in
        guard (element.response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
        return element.data
      }
      .decode(type: NewsResult.self, decoder: JSONDecoder())
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
   
  //MARK: Fetching NewsAPI & Save File in Memory for Background Tasks
  func fetchAndSave(for request: URLRequest) async throws {
    
    //fetching
    let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
    
    //saving
    guard let file = FileManager().backupFilePath() else { throw MyError.fileNil }
    try FileManager.default.removeItem(at: file)
    try data.write(to: file, options: [.atomic])
    print(file)
  }
}



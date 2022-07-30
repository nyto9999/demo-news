import Foundation
import Combine
import SwiftUI

protocol APIClient {
  var session: URLSession { get }
}

//MARK: Network request then decode
extension APIClient {
  
  //MARK: publisher way
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
  
  //MARK: aync way
  func asynFetch<T: Decodable>(with request: URLRequest, decodeType: T) async throws -> T {

    let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)

    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.httpNoResponse(url: request.url!) }
    guard let news = try? JSONDecoder()
      .decode(T.self, from: data)
    else { throw APIError.httpNoResponse(url: request.url!) }

    return news
  }
  
  func jsonDownloader(with request: URLRequest, type: String) {
    
    session.dataTask(with: request) { data, response, error in
      guard
        let data = data,
        error == nil
      else { return }
      
      if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        
        let pathWithFileName = documentDirectory.appendingPathComponent(type).appendingPathExtension("json")
        
        do {
          if FileManager.fileExists(filePath: pathWithFileName.path) {
            print("exist")
            try FileManager.default.removeItem(at: pathWithFileName)
          }
          
          try data.write(to: pathWithFileName, options: [.atomic])
          print(pathWithFileName)
        }
        catch {
          print(error.localizedDescription)
        }
      }
    }.resume()
  }
}

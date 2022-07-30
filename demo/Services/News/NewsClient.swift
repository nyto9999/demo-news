import UIKit
import Combine
import Resolver

final class NewsClient: APIClient, NewsClientProtocol {
  
  @Injected internal var session: URLSession
  
  // MARK: publisher way
  func getTopheadlines() -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.getTopheadlines.reuqest
    return fetch(with: request, decodeType: NewsResult())
  }
  
  func search(searchText: String) -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.search(searchText: searchText).reuqest
    return fetch(with: request, decodeType: NewsResult())
  }
  
  public func bgDownloadNews() {
    let request = NewsProvider.getTopheadlines.reuqest
    return jsonDownloader(with: request, type: Constants.NewsType.everything.rawValue)
  }
  
  
  // MARK: aync way
//  func getTopheadlines() async throws -> NewsResult {
//    let request = NewsProvider.getTopheadlines.reuqest
//    return try await fetch(with: request, decodeType: NewsResult())
//  }
//
//  func search(searchText: String) async throws -> NewsResult {
//    let request = NewsProvider.search(searchText: searchText).reuqest
//    return try await fetch(with: request, decodeType: NewsResult())
//  }
//
//  // MARK: Background actions
//  public func bgDownloadNews() {
//    let request = NewsProvider.getTopheadlines.reuqest
//    return jsonDownloader(with: request, type: Constants.NewsType.everything.rawValue)
//  }
  
}



enum APIError: Error {
   
  case httpNoResponse(url: URL)
  case decodingFailed(error: Swift.DecodingError)
  case networkFailed(error: URLError, url: URL)
  case unknown
}



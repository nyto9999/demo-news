import UIKit
import Combine
import Resolver

final class NewsClient: APIClient, NewsClientProtocol {
 
  @Injected internal var session: URLSession
  
  // MARK: publisher way
  func getTopheadlines() -> AnyPublisher<NewsResult, MyError> {
    let request = NewsProvider.getTopheadlines.reuqest
    return fetchAndDecode(for: request, decodeType: NewsResult())
  }
  
  func search(searchText: String) -> AnyPublisher<NewsResult, MyError> {
    let request = NewsProvider.search(searchText: searchText).reuqest
    return fetchAndDecode(for: request, decodeType: NewsResult())
  }
  
  func fetchAndSave() async throws {
    let request = NewsProvider.getTopheadlines.reuqest
    try await self.fetchAndSave(for: request)
  }
}

enum MyError: Error {
  case dataNil
  case fileNil
  case httpResponseFailed(url: URL)
  case decodingFailed(error: Swift.DecodingError)
  case networkFailed(error: URLError, url: URL)
  case unknown
}



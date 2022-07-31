import UIKit
import Combine
import Resolver

final class NewsClient: APIClient, NewsClientProtocol {
 
  @Injected internal var session: URLSession
  
  // MARK: publisher way
  func getTopheadlines() -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.getTopheadlines.reuqest
    return fetchAndDecode(with: request, decodeType: NewsResult())
  }
  
  func search(searchText: String) -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.search(searchText: searchText).reuqest
    return fetchAndDecode(with: request, decodeType: NewsResult())
  }
  
  func fetchAndSave() async throws {
    let request = NewsProvider.getTopheadlines.reuqest
    try await self.fetchAndSave(with: request)
  }
}

enum APIError: Error {
   
  case httpNoResponse(url: URL)
  case decodingFailed(error: Swift.DecodingError)
  case networkFailed(error: URLError, url: URL)
  case unknown
}



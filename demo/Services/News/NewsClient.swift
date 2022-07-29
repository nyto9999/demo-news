import UIKit
import Combine
import Resolver

final class NewsClient: APIClient, NewsClientProtocol {
   
  @Injected internal var session: URLSession
  
  // MARK: News List
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
}



enum APIError: Error {
   
  case decodingFailed(error: Swift.DecodingError)
  case networkFailed(error: URLError, url: URL)
  case unknown
}



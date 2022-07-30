import Foundation
import Resolver
import Combine

class MockNewsClient: APIClient, MockProtocol {
  
  var session: URLSession = URLSession(configuration: .default)
  
  //publisher
  func publisherTopheadlines() -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.getTopheadlines.reuqest
    return fetch(with: request, decodeType: NewsResult())
  }
  
  func publisherSearch(searchText: String) -> AnyPublisher<NewsResult, APIError> {
    let request = NewsProvider.search(searchText: searchText).reuqest
    return fetch(with: request, decodeType: NewsResult())
  }
  
  //async
  func asyncTopheadlines() async throws -> NewsResult {
    let request = NewsProvider.getTopheadlines.reuqest
    return try await asynFetch(with: request, decodeType: NewsResult())
  }
  
  func asynSearch(searchText: String) async throws -> NewsResult {
    let request = NewsProvider.search(searchText: searchText).reuqest
    return try await asynFetch(with: request, decodeType: NewsResult())
  }
}


protocol MockProtocol {
  
  //publisher way
  func publisherTopheadlines() -> AnyPublisher<NewsResult, APIError>
  
  func publisherSearch(searchText: String) -> AnyPublisher<NewsResult, APIError>
  
  //async way
  func asyncTopheadlines() async throws -> NewsResult

  func asynSearch(searchText: String) async throws -> NewsResult
}


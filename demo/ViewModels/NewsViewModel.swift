import UIKit
import Combine
import Resolver


final class NewsViewModel {
  @Injected private var client: NewsClient
}

extension NewsViewModel: NewsViewModelProtocol {
  
  //publisher way
  typealias newsPublisher = AnyPublisher<[News], APIError>
 
  func newsTopHeadlines() -> newsPublisher {
    return client.getTopheadlines().map { $0.news.sorted { $0 > $1 } }
      .eraseToAnyPublisher()
  }
  
  func search(searchText: String) -> newsPublisher {
    
    return client.search(searchText: searchText).map { $0.news.sorted { $0 > $1 } }
      .eraseToAnyPublisher()
  }
  
  // aysn way
//  func newsTopHeadlines() async throws -> [News] {
//    return try await client.getTopheadlines().news.sorted(by: {$0 < $1})
//  }
//  func search(searchText: String) async throws {
//    try await client.search(searchText: searchText).news.sorted(by: { $0 < $1 })
//  }
 
}



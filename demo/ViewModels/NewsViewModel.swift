import UIKit
import Combine
import Resolver

struct NewsViewModel {
  @Injected private var client: NewsClient
}

extension NewsViewModel: NewsViewModelProtocol {
 
  typealias newsPublisher = AnyPublisher<[News], APIError>
  
  //MARK: - news client actions
  
  func newsTopHeadlines() -> newsPublisher {
    return client.getTopheadlines().map { $0.news.sorted { $0 > $1 } }
      .eraseToAnyPublisher()
  }
  
  func search(searchText: String) -> newsPublisher {
    
    return client.search(searchText: searchText).map { $0.news.sorted { $0 > $1 } }
      .eraseToAnyPublisher()
  }
}



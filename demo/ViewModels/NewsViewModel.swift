import UIKit
import Combine
 
final class NewsViewModel {
  var client: NewsClientProtocol
  init(client: NewsClient = NewsClient()) {
    self.client = client
  }
}

extension NewsViewModel: NewsViewModelProtocol {
  
  typealias newsPublisher = AnyPublisher<[News], APIError>
  
  //MARK: - news client actions
  func newsEverything(isAscending: Bool = true) -> newsPublisher {
    
    let new = isAscending ?
    
    client.getEverything().map { $0.news.sorted { $0 > $1 } }
      .eraseToAnyPublisher()
    :
    client.getEverything().map { $0.news.sorted { $0 < $1 } }
      .eraseToAnyPublisher()
    return new
  }
  
  func newsTopHeadlines(isAscending: Bool = true) -> newsPublisher {
    
    let news = isAscending ?
    
    client.getTopheadlines().map { $0.news.sorted { $0 > $1 } }
      .eraseToAnyPublisher()
    :
    client.getTopheadlines().map { $0.news.sorted { $0 < $1 } }
      .eraseToAnyPublisher()
    
    return news
  }
  
  func search(searchText: String, isAscending: Bool) -> newsPublisher {
    
    let news = isAscending ?
    
    client.search(searchText: searchText).map { $0.news.sorted { $0 > $1 } }
      .eraseToAnyPublisher()
    :
    client.search(searchText: searchText).map { $0.news.sorted { $0 < $1 } }
      .eraseToAnyPublisher()
    
    return news
  }
  
  
}



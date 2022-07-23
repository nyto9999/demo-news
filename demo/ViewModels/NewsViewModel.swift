import UIKit
import Combine

protocol NewsViewModelProtocol {
  func newsTopHeadlines(asc: Bool) -> AnyPublisher<[News], APIError>
}

final class NewsViewModel {
  
  var client: NewsClientProtocol
  
  init(client: NewsClient = NewsClient()) {
    self.client = client
  }
}

extension NewsViewModel: NewsViewModelProtocol {
  
  //MARK: NewsViewModelProtocol
  func newsTopHeadlines(asc: Bool = true) -> AnyPublisher<[News], APIError> {
    return client.getTopheadlines()
      .map { result in
        result.news.sorted { $0 > $1 }
      }
      .eraseToAnyPublisher()
  }
  
  
}



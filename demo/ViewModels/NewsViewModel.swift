import UIKit
import Combine

protocol NewsViewModelProtocol {
  func News() -> AnyPublisher<[News], NetworkError>
}

final class NewsViewModel {
  var newsPublisher: NewsPublisher
  
  init(newPublisher: NewsPublisher = NewsPublisher()) {
    self.newsPublisher = newPublisher
  }
}

extension NewsViewModel: NewsViewModelProtocol {
  
  //MARK: NewsViewModelProtocol
  func News() -> AnyPublisher<[News], NetworkError> {
    return newsPublisher.fetchNews
      .map { result in
        result.news.sorted { $0 > $1 }
      }
      .eraseToAnyPublisher()
  }
}



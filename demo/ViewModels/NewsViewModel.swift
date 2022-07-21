import UIKit
import Combine

protocol NewsViewModelProtocol {
  func News() -> AnyPublisher<News, GenericError>
  func News(by keywordDict: [String:String]) -> AnyPublisher<News, GenericError>
}

final class NewsViewModel {}

extension NewsViewModel: NewsViewModelProtocol {
  
  //MARK: NewsViewModelProtocol
  func News(by keywordDict: [String : String]) -> AnyPublisher<News, GenericError> {
    return NewsPublisher(keyword: keywordDict).fetchNews
  }
  
  func News() -> AnyPublisher<News, GenericError> {
    return NewsPublisher().fetchNews
  }
}



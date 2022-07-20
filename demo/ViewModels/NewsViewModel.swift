import UIKit
import Combine

final class NewsViewModel: ObservableObject {
  @Published var news = News()
  init() {}
}

extension NewsViewModel {
  
  //MARK: publishers action
  func decodeNews() -> AnyPublisher<News, GenericError> {
    return NewsPublisher().decodeData(from: Network().request())
  }
  
  func decodeNews(by keywords: [String:String]) -> AnyPublisher<News, GenericError> {
    return NewsPublisher()
      .decodeData(from: Network(keyword: keywords).request())
  }
}



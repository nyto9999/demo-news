import UIKit
import Resolver

protocol NewsViewModelProtocol {
  
  typealias newsFeed = (news: [News], images: [Int:UIImage?])
  func fetchingNewsFeed(type: NewsType) async throws -> newsFeed
}

final class NewsViewModel {
  //MARK: Properties
  @Injected private var newsClient: NewsClient
}

extension NewsViewModel: NewsViewModelProtocol {
  
  typealias newsFeed = (news: [News], images: [Int : UIImage?])
  
  func fetchingNewsFeed(type: NewsType) async throws -> newsFeed {
    return try await newsClient.receiveData(type: type)
  }
}



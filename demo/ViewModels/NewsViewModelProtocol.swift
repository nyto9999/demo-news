import Foundation
import Combine

protocol NewsViewModelProtocol {
  //publisher way
  typealias newsFeed = (news: [News], ImageData: [Int:Data])
  typealias newsPublisher = AnyPublisher<[News], MyError>
  
  func search(searchText: String) -> newsPublisher
  
  
  // 1 called by view
  func fetchingNewsAndImageData() async throws -> newsFeed
  
  // 2 publisher fetching news
  func _fetchingNewsData() async -> [News]
  
  // 3 convert feteched news imgString to img data
  func _convertUrlToImage(for news: [News]) async throws -> newsFeed
  
  // 4
  func _downloadImage(urlString: String?) async throws -> Data?
}

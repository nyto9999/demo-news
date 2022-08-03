import UIKit
import Combine
import Resolver

final class NewsViewModel {
  @Injected private var newsClient: NewsClient
  var news = ([News], [Int:Data]).self
  var subscriptions = Set<AnyCancellable>()
}

extension NewsViewModel: NewsViewModelProtocol {
 
  typealias newsFeed = (news: [News], ImageData: [Int:Data])
  typealias newsPublisher = AnyPublisher<[News], MyError>
  
  func search(searchText: String) -> newsPublisher {
    return newsClient.search(searchText: searchText).map { $0.news.sorted { $0 > $1 } }
      .eraseToAnyPublisher()
  }
  
  // called by view
  func fetchingNewsAndImageData() async throws -> newsFeed {
    let fetchedNews = await _fetchingNewsData()
    return try await _convertUrlToImage(for: fetchedNews)
  }
  
  func _fetchingNewsData() async -> [News] {
    return await withCheckedContinuation { continuation in
      newsClient.getTopheadlines().map { $0.news.sorted { $0 > $1 } }
        .receive(on: DispatchQueue.main)
        .sink {completion in
          print("completion")
        } receiveValue: { news in
          continuation.resume(returning: news)
        }
        .store(in: &subscriptions)
    }
  }
  
  func _convertUrlToImage(for news: [News]) async throws -> newsFeed {
    var dict = [Int:Data]()
    let taskResult = (index: Int, image: Data?).self
    //async
    try await withThrowingTaskGroup(of: taskResult) { [unowned self] group in
      //concurrent
      for index in 0..<news.count {
        group.addTask {
          let imgData = try await self._downloadImage(urlString: news[index].urlToImage)
          return (index, imgData)
        }
      }
      //async wait for concurrent
      for try await newsArray in group {
        dict[newsArray.index] = newsArray.image
      }
    }
    return (news,dict)
  }
  
  func _downloadImage(urlString: String?) async throws -> Data? {
    guard let urlString = urlString,
          let url = URL(string: urlString)
    else { return Data() }
    return try await URLSession.shared.data(from: url).0
  }
   
  func loadBackupNews() async throws -> [News] {
    try await newsClient.fetchAndSave()
    return try self._decodeBackupData()
  }
  
  private func _decodeBackupData() throws -> [News] {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: FileManager().backupFilePath()!.path)) else { throw MyError.dataNil }
    return try JSONDecoder().decode(NewsResult.self, from: data).news
  }
}



import UIKit
import Combine
import Resolver

final class NewsViewModel {
  
  @Injected private var newsClient: NewsClient
  var news = ([News], [Int:Data]).self
  var subscriptions = Set<AnyCancellable>()
  private(set) var verifiedCount = 0
}

extension NewsViewModel: NewsViewModelProtocol {
 
  typealias newsFeed = (news: [News], images: [Int : UIImage?])
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
    var imageSet = [Int:UIImage?]()
     
    //async
    let taskResult = (index: Int, image: UIImage?).self
    try await withThrowingTaskGroup(of: taskResult) { [unowned self] group in
      //concurrent
      for index in 0..<news.count {
        group.addTask {
          let img = await self.imageDownloader(urlString: news[index].urlToImage)
          return (index, img)
        }
      }
      //async wait for concurrent
      
      for try await imageDownloader in group {
        imageSet[imageDownloader.index] = imageDownloader.image
      }
    }
    return (news,imageSet)
  }
  
  func imageDownloader(urlString: String?) async -> UIImage? {
    guard let urlString = urlString,
          let url = URL(string: urlString),
          let data = try? await URLSession.shared.data(from: url).0
    else { return UIImage() }
    
    return UIImage(data: data)
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



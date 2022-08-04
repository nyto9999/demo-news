import UIKit
import Combine
import Resolver

enum NewsType {
  case `default`
  case search(searchText: String)
}

final class NewsViewModel {
  //MARK: Properties
  @Injected private var newsClient: NewsClient
  var subscriptions = Set<AnyCancellable>()
}

extension NewsViewModel: NewsViewModelProtocol {
  
  typealias newsFeed = (news: [News], images: [Int : UIImage?])
  typealias newsPublisher = AnyPublisher<[News], MyError>
   
  func search(searchText: String) -> newsPublisher {
    return newsClient.search(searchText: searchText).map { $0.news.sorted { $0 > $1 } }
      .eraseToAnyPublisher()
  }
   
  // called by view
  func fetchingNewsAndImageData(type: NewsType) async throws -> newsFeed {
    let fetchedNews = await fetchingNewsData(type: type)
    return try await concurrentImagesDownloader(for: fetchedNews)
  }
   
  func fetchingNewsData(type: NewsType) async -> [News] {
    
    switch type {
      case .default:
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
      case .search(let searchText):
        print(searchText)
        break
    }
    
    //nil
    return [News]()
  }
  
  func concurrentImagesDownloader(for news: [News]) async throws -> newsFeed {
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



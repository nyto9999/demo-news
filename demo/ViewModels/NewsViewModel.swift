import UIKit
import Combine
import Resolver

final class NewsViewModel {
  @Injected private var newsClient: NewsClient
}

extension NewsViewModel: NewsViewModelProtocol {
  
  //publisher way
  typealias newsPublisher = AnyPublisher<[News], MyError>
  
  func newsTopHeadlines() -> newsPublisher {
    return newsClient.getTopheadlines().map { $0.news.sorted { $0 > $1 } }
      .eraseToAnyPublisher()
  }
  
  func search(searchText: String) -> newsPublisher {
    return newsClient.search(searchText: searchText).map { $0.news.sorted { $0 > $1 } }
      .eraseToAnyPublisher()
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



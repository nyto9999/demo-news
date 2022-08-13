import Foundation

protocol APIClient {}

extension APIClient {
  
  func fetch(for request: URLRequest) async throws -> Data {
    var request = request
    request.setValue("402d3a3e2bb44751b9d8b9618c6a6fca", forHTTPHeaderField: "X-Api-Key")
    request.addValue("chunked", forHTTPHeaderField: "Transfer-Encoding")
    request.addValue("gizp, compress, deflate", forHTTPHeaderField: "Accept-Encoding")
    request.addValue("max-age=\(60 * 60)", forHTTPHeaderField: "Cache-Control")
    request.addValue("1", forHTTPHeaderField: "DNT") //prevent ad tracking
    
//    request.addValue("en-us;en;q=0.3", forHTTPHeaderField: "Accept-Language")
    
    let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badURL) }
    
    dump(response)
    
    return data
  }
 
  
  func decoder<T: Decodable>(for data: Data, type: T) throws -> T {
      return try JSONDecoder().decode(T.self, from: data)
  }
  
  //MARK: Fetching NewsAPI & Save File in Memory for Background Tasks
  func storeData(for request: URLRequest) async throws {
    let data = try await self.fetch(for: request)
    guard let file = FileManager().backupFilePath() else { throw MyError.fileNil }
    try FileManager.default.removeItem(at: file)
    try data.write(to: file, options: [.atomic])
    print(file)
  }
}



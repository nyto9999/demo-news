import UIKit

class ImageLoader {
  
  enum DownloadState {
     case inProgress(Task<UIImage, Error>)
     case completed(UIImage)
     case failed
   }
  
  private(set) var cache: [String: UIImage] = [:]
  
  func add(_ image: UIImage, forKey key: String) {
    cache[key] = image
  }
  
  func image(_ urlString: String) async throws -> UIImage {
    if let cached = cache[urlString] {
      return cached
    }

    let download: Task<UIImage, Error> = Task.detached {
      guard let url = URL(string: urlString) else {
        throw MyError.unknown
      }
      print("Download: \(url.absoluteString)")
      let data = try await URLSession.shared.data(from: url).0
      
      if let data = UIImage(data: data)?.jpeg(.lowest),
         let img = UIImage(data: data)
      {
        return resizeImage(image: img, width: 320)
      }
      return resizeImage(image: UIImage(systemName: "circle")!, width: 320)
    }

    cache[urlString] = try await download.value
    
    do {
      let result = try await download.value
      add(result, forKey: urlString)
      return result
    } catch {
      cache[urlString] = UIImage()
      throw error
    }
  }

  func clear() {
    cache.removeAll()
  }
}

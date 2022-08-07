import Foundation
import UIKit

enum ImageRecordState {
  case new, downloaded, failed
}

class ImageRecord {
  var key: String
  let url: URL?
  var state = ImageRecordState.new
  var image = UIImage(named: "Placeholder")
  
  init(key: String, url: URL?) {
    self.key = key
    self.url = url
  }
}

class PendingOperations {
  lazy var downloadsInProgress: [IndexPath: Operation] = [:]
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download queue"
    return queue
  }()
  
  
}

class ImageDownloader: Operation {
  let imageRecord: ImageRecord
  
  init(_ imageRecord: ImageRecord) {
    self.imageRecord = imageRecord
  }
  
  override func main() {
    if isCancelled { return }
    
    guard let url = imageRecord.url else { return }
    guard let imageData = try? Data(contentsOf: url) else { return }
    if isCancelled { return }
    
    if !imageData.isEmpty {
      guard let data = UIImage(data: imageData)?.jpeg(.low) else { return }
      imageRecord.image = resizeImage(image: UIImage(data: data)!, width: 320)
      imageRecord.state = .downloaded
    }
    else {
      imageRecord.state = .failed
      imageRecord.image = UIImage(named: "Failed")
    }
  }
}


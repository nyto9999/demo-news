import Foundation
import UIKit
import Accelerate

extension URLRequest {
  mutating func setHeader(for httpHeaderField: String, with value: String) {
    setValue(value, forHTTPHeaderField: httpHeaderField)
  }
}

extension FileManager {
  func backupFilePath() -> URL? {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    return documentDirectory?.appendingPathComponent("news").appendingPathExtension("json")
  }
  
  class func fileExists(filePath: String) -> Bool {
      var isDirectory = ObjCBool(false)
      return self.default.fileExists(atPath: filePath, isDirectory: &isDirectory)
  }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
 
func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
  let size = CGSize(width: width, height:
                      image.size.height * width / image.size.width)
  let renderer = UIGraphicsImageRenderer(size: size)
  let newImage = renderer.image { (context) in
    image.draw(in: renderer.format.bounds)
  }
  return newImage
}

 

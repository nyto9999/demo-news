import Foundation

extension FileManager {
    class func fileExists(filePath: String) -> Bool {
        var isDirectory = ObjCBool(false)
        return self.default.fileExists(atPath: filePath, isDirectory: &isDirectory)
    }
}

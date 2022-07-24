import Foundation
import Resolver

@testable import demo
extension Resolver {
  static var mock = Resolver(parent: .main)
  
  static func registerMockServices() {
    root = Resolver.mock
    defaultScope = .application
    
    Resolver.mock.register { MockNewsClient() }.implements(NewsClientProtocol.self)
  }
}

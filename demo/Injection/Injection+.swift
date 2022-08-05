import Foundation
import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    defaultScope = .graph
    
    //default
    register { URLSession(configuration: .default) }
    register { NewsClient() }.implements(NewsClientProtocol.self)
    register { NewsViewModel() }
      .implements(NewsViewModelProtocol.self)
    
  }
}

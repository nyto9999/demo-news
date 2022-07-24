import Resolver
import XCTest
import Combine

@testable import demo
class NewsViewModelTest: XCTestCase {

  var sut: AnyPublisher<NewsResult, APIError>?
  var cancellable: Set<AnyCancellable>?
  
  @LazyInjected var client: MockNewsClient
  
  override func setUp() {
    super.setUp()
    cancellable = Set<AnyCancellable>()
    Resolver.registerMockServices()
  }

  override func tearDown() {
    super.tearDown()
    sut = Empty().eraseToAnyPublisher()
    cancellable = nil
  }
  
  func testClientGetEverythingNotNil() {
    sut = client.getEverything()
    XCTAssertNotNil(sut)
  }
  
  func testClientgetTopheadlinesNotNil() {
    sut = client.getEverything()
    XCTAssertNotNil(sut)
  }
  
  func tesetClientSearchNotNil() {
    sut = client.search(searchText: "trump")
    XCTAssertNotNil(sut)
  }
  

  

}

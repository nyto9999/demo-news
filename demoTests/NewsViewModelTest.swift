import Resolver
import XCTest
import Combine

@testable import demo
class NewsViewModelTest: XCTestCase {

  private var cancellable = Set<AnyCancellable>()
  
  @LazyInjected var client: MockNewsClient
  
  override func setUp() {
    super.setUp()
    Resolver.registerMockServices()
    cancellable = []
  }

  override func tearDown() {
    super.tearDown()
  }
  
  func testClientGetEverythingSuccessfully() {
    
    var newsResult:NewsResult?
    var error: APIError?
    
    measure {
      let expectation = self.expectation(description: "wait client get everything")
      client.getEverything()
        .sink (receiveCompletion: { completion in
          switch completion {
            case .finished:
              break
            case .failure(let encounteredError):
              error = encounteredError
          }
          
          expectation.fulfill()
        }, receiveValue: { value in
          newsResult = value
        })
        .store(in: &cancellable)
        
        waitForExpectations(timeout: 3)
      
      XCTAssertNil(error)
      XCTAssertNotNil(newsResult)
    }
  }
  
  func testClientTopHeadlinesSuccessfully() {
    
    var newsResult:NewsResult?
    var error: APIError?
    
    measure {
      let expectation = self.expectation(description: "wait client get topheadlines")
      client.getTopheadlines()
        .sink (receiveCompletion: { completion in
          switch completion {
            case .finished:
              break
            case .failure(let encounteredError):
              error = encounteredError
          }
          
          expectation.fulfill()
        }, receiveValue: { value in
          newsResult = value
        })
        .store(in: &cancellable)
        
        waitForExpectations(timeout: 3)
      
      XCTAssertNil(error)
      XCTAssertNotNil(newsResult)
    }
  }
  
  func testClientSearchSuccessfully() {
    
    var newsResult:NewsResult?
    var error: APIError?
    
    measure {
      let expectation = self.expectation(description: "wait client get topheadlines")
      client.search(searchText: "ukraine")
        .sink (receiveCompletion: { completion in
          switch completion {
            case .finished:
              break
            case .failure(let encounteredError):
              error = encounteredError
          }
          
          expectation.fulfill()
        }, receiveValue: { value in
          newsResult = value
        })
        .store(in: &cancellable)
        
        waitForExpectations(timeout: 3)
      
      XCTAssertNil(error)
      XCTAssertNotNil(newsResult)
    }
  }
  

  

}

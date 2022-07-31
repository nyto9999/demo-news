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
  
  func testClientTopHeadlinesSuccessfully() {
    
    var newsResult:NewsResult?
    var error: MyError?
    
    measure {
      let expectation = self.expectation(description: "wait client get topheadlines")
      client.publisherTopheadlines()
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
    var error: MyError?
    
    measure {
      let expectation = self.expectation(description: "wait client get topheadlines")
      client.publisherSearch(searchText: "ukraine")
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
        
        waitForExpectations(timeout: 5)
      
      XCTAssertNil(error)
      XCTAssertNotNil(newsResult)
    }
  }
  
  func testAsynHeadline() {
    measure {
      let expectation = self.expectation(description: "asyn topheadline")

      Task.detached(priority: .background) {
        do {
          let news = try await self.client.asyncTopheadlines()
          expectation.fulfill()
          DispatchQueue.main.async {
            XCTAssertNotNil(news)
          }
        }
        catch {
          XCTAssertNil(error)
        }
        
      }
      
      waitForExpectations(timeout: 5)
    }
  }
  

  

}

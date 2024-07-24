//
//  MoonDuckTests.swift
//  MoonDuckTests
//
//  Created by suni on 5/22/24.
//

import XCTest

@testable import MoonDuck
import OHHTTPStubs


final class MoonDuckTests: XCTestCase {
    var provider: AppServices?
    var stub: HTTPStubsDescriptor?
    
    override func setUp() {
        super.setUp()
        HTTPStubs.setEnabled(true)
        stub = stubErrorForAPI()
        
        provider = AppServices(authService: AuthService(),
                                userService: UserService(),
                                reviewService: ReviewService(),
                               programSearchService: ProgramSearchService(), 
                               shareService: ShareService())
    }
    
    override func tearDown() {
        if let stub = stub {
            HTTPStubs.removeStub(stub) // Remove the stub
        }
        HTTPStubs.setEnabled(false) // Disable HTTP stubs
        
        super.tearDown()
    }
    
    func stubErrorForAPI() -> HTTPStubsDescriptor {
       let condition: HTTPStubsTestBlock = { request in
           return request.url?.absoluteString.contains(MoonDuckAPI.baseUrl() + "/api/review") ?? false
       }
       
       let response: HTTPStubsResponseBlock = { request in
           // NSError Test
           let nsError = NSError(domain: NSURLErrorDomain, code: NSURLErrorSecureConnectionFailed, userInfo: nil)
           
           // Status Code Test
           let statusError = HTTPStubsResponse(data: Data(), statusCode: 403, headers: nil)
          
           // API Error Test
           let errorResponse = ["code": "AU003", "message": "만료된 토큰입니다."]
           let data = try! JSONSerialization.data(withJSONObject: errorResponse, options: [])
           let apiError = HTTPStubsResponse(data: data, statusCode: 403, headers: nil)
           
           return apiError
       }
       
        return OHHTTPStubs.stub(condition: condition, response: response)
   }
    
    func testAsyncNetworkCall() {
        let expectation = self.expectation(description: "Request should timeout")

        AuthManager.shared.login(auth: Auth(loginType: .kakao, id: "TEST")) { _, _ in
            let request = GetReviewRequest(category:"MOVIE", filter: "LATEST", offset: 0, size: 30)
            self.provider?.reviewService.getReview(request: request) { succeed, failed in
                if let succeed {
                    Log.debug("리뷰 검색 성공 \(succeed.reviews)")
                    expectation.fulfill()
                } else {
                    // 오류 발생
                    Log.error("오류 발생 \(String(describing: failed))")
                }
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

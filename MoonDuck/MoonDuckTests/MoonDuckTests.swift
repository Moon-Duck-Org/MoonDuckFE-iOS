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
    var provider: AppServices!

    override func setUp() {
        HTTPStubs.setEnabled(true)
        super.setUp()
        provider = AppServices(authService: AuthService(),
                                userService: UserService(),
                                reviewService: ReviewService(),
                               programSearchService: ProgramSearchService(), 
                               shareService: ShareService())
        
        AuthManager.default.login(auth: Auth(loginType: .kakao, id: "TEST")) { _, _ in
        }
    }
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testAsyncNetworkCall() {
         stub(condition: isHost("moonduck.o-r.kr")) { _ in
             // NSError Test
             let nsError = NSError(domain: NSURLErrorDomain, code: NSURLErrorSecureConnectionFailed, userInfo: nil)
             
             // Status Code Test
             let statusError = HTTPStubsResponse(data: Data(), statusCode: 500, headers: nil)
            
             // API Error Test
             let errorResponse = ["code": "BO001", "message": "존재하지 않는 리뷰"]
             let data = try! JSONSerialization.data(withJSONObject: errorResponse, options: [])
             let apiError = HTTPStubsResponse(data: data, statusCode: 400, headers: nil)
             
             return apiError
         }

         let expectation = self.expectation(description: "Request should timeout")
        
        let request = GetReviewRequest(category:"MOVIE", filter: "LATEST", offset: 0, size: 30)
        provider.reviewService.getReview(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                Log.debug("리뷰 검색 성공 \(succeed.reviews)")
            } else {
                // 오류 발생
                if let code = failed {
                    if code.isReviewError {
                        Log.error("리뷰 관련 오류 발생")
                        expectation.fulfill()
                        return
                    }
                }
                Log.error("오류 발생 \(String(describing: failed))")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
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

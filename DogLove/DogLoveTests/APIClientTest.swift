//
//  APIClientTest.swift
//  DogLoveTests
//
//  Created by M. Ensar Baba on 25.11.2020.
//

import XCTest
@testable import DogLove

class APIClientTest: XCTestCase {
   
    //Subject under Test
    var sut: APIClient?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = APIClient.shared
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func testItemsFetching() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // API Service Instance
        let sut = self.sut!
        
        // When searching poiList
        let expect = XCTestExpectation(description: "callback")
        let parameters: DogSearchRequest = ["q": name, "limit": "5", "page": "0", "order": "DESC"]
     
        sut.searchDogs(params: parameters, method: .GET, endPoint: .search) { (result) in
            expect.fulfill()
            switch result {
            case .success(let response):
                XCTAssertEqual(response.count, 5, "Limit parameter has given 5 therefore we are waiting 5 items")
                for item in response {
                    XCTAssertNotNil(item.id)
                    XCTAssertNotNil(item.url)
                }
            case .failure(let error):
                XCTAssertNotNil(error.rawValue)
            }
        }
        wait(for: [expect], timeout: 10.0)
    }
}

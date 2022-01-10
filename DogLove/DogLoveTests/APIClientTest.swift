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
    var sut: APIClientMock!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = APIClientMock()
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
        
        // When searching poiList
        let expect = XCTestExpectation(description: "callback")
        let parameters: DogSearchRequest = ["q": "terrier", "limit": "1", "page": "0", "order": "DESC"]
     
        sut.searchDogs(params: parameters) { (result) in
            expect.fulfill()
            switch result {
            case .success(let response):
                XCTAssertEqual(response.count, 1, "Limit parameter has given 1 therefore we are waiting 1 items")
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
class APIClientMock: APIClientProtocol {
    func searchDogs(params: DogSearchRequest, completion: @escaping (Result<DogSearchResponse, APIError>) -> Void) {
        let item = DogSearchResponseElement(breeds: [], id: "", url: "", width: 0, height: 0)
        completion(.success([item]))
    }
}

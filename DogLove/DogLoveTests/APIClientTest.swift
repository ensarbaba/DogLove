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
    
    func testItemsFetching() async throws {
        let expect = XCTestExpectation(description: "callback")
        let parameters: DogSearchRequest = ["q": "terrier", "limit": "1", "page": "0", "order": "DESC"]
        let response = try await sut.searchDogs(params: parameters)

        XCTAssertEqual(response.count, 1, "Limit parameter has given 1 therefore we are waiting 1 items")

        for item in response {
            expect.fulfill()
            XCTAssertNotNil(item.id)
            XCTAssertNotNil(item.url)
        }
        await fulfillment(of: [expect], timeout: 2.0)
    }
}
class APIClientMock: APIClientProtocol {
    func searchDogs(params: DogLove.DogSearchRequest) async throws -> DogLove.DogSearchResponse {
        let item = DogSearchResponseElement(breeds: [], id: "", url: "", width: 0, height: 0)
        return [item]
    }
}

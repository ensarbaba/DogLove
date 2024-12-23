//
//  DogSearchViewModelTest.swift
//  DogLoveTests
//
//  Created by M. Ensar Baba on 25.11.2020.
//

import XCTest
@testable import DogLove

@MainActor
class DogSearchViewModelTest: XCTestCase {
    //Subject under Test
    var sut: DogSearchViewModel!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = DogSearchViewModel(apiService: APIClientMock())
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func testFetchingItems() {
        
        let fetchExpectation = XCTestExpectation(description: "initial data fetched by search")
        
        sut.viewHandler = { [weak self] viewAction in
            guard let self = self else {return}
            switch viewAction {
            case .showMessage(_):
                XCTAssert(false, "Some error occured")
            case .reloadData:
                if self.sut.dogsRowCount > 0 {
                    fetchExpectation.fulfill()
                }
            case .requestInProgress(let progress):
                if progress {
                    XCTAssert(progress, "Request in progress")
                } else {
                    XCTAssertFalse(progress, "Request done")
                }
            case .insertRows(_):
                break
            }
        }
        Task {
            await sut.searchDogs(for: "terrier")
        }
        wait(for: [fetchExpectation], timeout: 2.0)
    }
}

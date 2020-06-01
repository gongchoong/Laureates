//
//  NobelLaureatesTests.swift
//  NobelLaureatesTests
//
//  Created by chris davis on 2/16/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import XCTest
@testable import NobelLaureates

class NobelLaureatesTests: XCTestCase {
    
    var sut: MainViewModel?
    var mockApiService: MockApiService?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        mockApiService = MockApiService()
        guard let mockApi = mockApiService else {return}
        sut = MainViewModel(mockApi)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        mockApiService = nil
        super.tearDown()
    }
    
    func testFetchCalled(){
        guard let sut = sut, let mockApi = mockApiService else {return}
        //Given
        mockApi.laureates = [Laureate]()
        //When
        sut.fetch()
        //Assert
        XCTAssertTrue(mockApi.isFetchCalled)
        
    }
    
    func testFetchFailure(){
        guard let sut = sut, let mockApi = mockApiService else {return}
        //Given
        let error = ApiServiceError.dataFetchError
        //When
        sut.fetch()
        mockApi.fail(error)
        //Assert
        XCTAssertEqual("\(error)", sut.errorMessage)
    }
    
    func testTableviewReload(){
        guard let sut = sut, let mockApi = mockApiService else {return}
        let expect = XCTestExpectation(description: "tableview is reloaded")
        DataGenerator().generateData { (laureates) in
            //Given
            mockApi.laureates = laureates
            sut.reloadTableViewClosure = { () in
                expect.fulfill()
            }
            //When
            sut.fetch()
            mockApi.successful()
        }
        //Assert
        wait(for: [expect], timeout: 3.0)
    }
    
    func testProcess(){
        guard let sut = sut, let mockApi = mockApiService else {return}
        DataGenerator().generateData { (laureates) in
            //Given
            mockApi.laureates = laureates
            //when
            sut.fetch()
            mockApi.successful()
            
            //Assert
            XCTAssertEqual(laureates.count, sut.numberOfCells)
        }
    }
    
    func testSort(){
        guard let sut = sut, let mockApi = mockApiService else {return}
        DataGenerator().generateData { (laureates) in
            //Given
            mockApi.laureates = laureates
            sut.yearInput = 1933
            sut.latitudeInput = -44.493491
            sut.longitudeInput = 130.39483939
            //When
            sut.fetch()
            mockApi.successful()
            let sortedArray = sut.getSortedArray()
            //Assert
            for i in 0...sortedArray.count{
                guard i+1 < sortedArray.count else {break}
                let j = i+1
                //XCTAssertTrue(sut.getJumps(laureate: sortedArray[i]) <= sut.getJumps(laureate: sortedArray[j]))
                XCTAssertLessThanOrEqual(sut.getJumps(laureate: sortedArray[i]), sut.getJumps(laureate: sortedArray[j]))
            }
        }
    }
    
    func testGetViewModel(){
        guard let sut = sut, let mockApi = mockApiService else {return}
        DataGenerator().generateData { (laureates) in
            //Given
            mockApi.laureates = laureates
            sut.yearInput = 1993
            sut.latitudeInput = 32.4394718293
            sut.longitudeInput = -89.384734
            //When
            sut.fetch()
            mockApi.successful()
            let sortedArray = sut.getSortedArray()
            //Assert
            for i in 0...sortedArray.count-1{
                XCTAssertEqual("\(sortedArray[i].firstName) \(sortedArray[i].lastName)", sut.getViewModel(indexPath: IndexPath(row: i, section: 0)).fullName)
            }
        }
    }
}

//dependency injection
class MockApiService: ApiServiceProtocol {
    
    var isFetchCalled = false
    var laureates = [Laureate]()
    var completeClosure: ((Bool, [Laureate], ApiServiceError?)->())?
    
    func fetchNobelPrizeData(completion: @escaping (Bool, [Laureate], ApiServiceError?) -> ()) {
        isFetchCalled = true
        completeClosure = completion
    }
    
    //mimic data fetch success
    func successful(){
        completeClosure?(true, laureates, nil)
    }
    
    //mimic data fetch failure
    func fail(_ error: ApiServiceError?){
        completeClosure?(false, laureates, error)
    }
}

class DataGenerator{
    func generateData(completion: @escaping([Laureate])->()){
        guard let path = Bundle.main.path(forResource: "nobel-prize-laureates", ofType: "json") else {
            print("download error")
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let laureates = try decoder.decode([Laureate].self, from: data)
            completion(laureates)
        }catch let error{
            print(error.localizedDescription)
            return
        }
        
    }
}

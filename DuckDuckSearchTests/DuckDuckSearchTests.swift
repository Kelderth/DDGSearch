//
//  DuckDuckSearchTests.swift
//  DuckDuckSearchTests
//
//  Created by Eduardo Santiz on 3/7/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import XCTest

@testable import DuckDuckSearch

class DuckDuckSearchTests: XCTestCase {
    var vm: SearchViewModel!
    var dp: DataPersistenceService!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vm = SearchViewModel()
        dp = DataPersistenceService()
        vm.loadDataFromDP()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSearchTermArraySize() {
        let arraySizeTest = vm.searchTermArraySize()
        XCTAssertTrue(vm.searchTermsBackup.count == arraySizeTest, "The searchTerms array is out of date.")
        print("arraySizeTest: \(arraySizeTest) vs searchTermsBackup: \(vm.searchTermsBackup.count)")
    }
    
    func testSaveSearchTerm_WillFailToSaveDuplicateTerm_ReturnFalse() {
        let searchTerm: String = "Eduardo"
        vm.saveSearchTerm(term: searchTerm) { (result) in
            XCTAssertFalse(result, "\(searchTerm) was saved succesfully.")
        }
    }
    
    func testSaveSearchTerm_WillSaveNewTerm_ReturnTrue() {
        let searchTerm: String = "Eduardos"
        vm.saveSearchTerm(term: searchTerm) { (result) in
            XCTAssertTrue(result, "\(searchTerm) already exists.")
        }
    }
    
    func testDeleteFromSearchTerm_WillDeleteTerm_ReturnTrue() {
        let index: Int = 0
        vm.deleteFromSearchTerm(index: index) { (response) in
            XCTAssertTrue(response, "\(index) does not exists in CoreData.")
        }
    }
    
    func testDeleteFromSearchTerm_WontDeleteTerm_ReturnFalse() {
        let index: Int = 12
        vm.deleteFromSearchTerm(index: index) { (response) in
            XCTAssertFalse(response, "\(index) was deleted succesfully.")
        }
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

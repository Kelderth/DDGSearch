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
    
    func testFilterTableViewContent_WillFilterContent_ReturnTrue() {
        let filterTerm: String = "B"
        vm.filterTableViewContent(text: filterTerm) { (response) in
            XCTAssertTrue(response, "No matches founded for \"\(filterTerm)\"")
        }
        
    }
    
    func testFilterTableViewContent_WontFilterContent_ReturnFalse() {
        let filterTerm: String = "Bars"
        vm.filterTableViewContent(text: filterTerm) { (response) in
            XCTAssertFalse(response, "\(self.vm.searchTerms.count) matches were founded!")
        }
    }
    
    func testDownloadResult_WillDownloadData_NotNil() {
        let term: String = "Cat"
        let termURL: URL = URL(string: "https://api.duckduckgo.com?q=\(term)&format=json&pretty=1&no_html=1&skip_disambig=1")!
        
        let expectation = XCTestExpectation(description: "downloadResult")
        
        vm.downloadResult(for: termURL) { (DDGModel) in
            XCTAssertNotNil(DDGModel, "Error, \(term) did not return any result.")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testDownloadResult_WontDownloadData_ResultFalse() {
        let term: String = "Camaron"
        let termURL: URL = URL(string: "https://api.duckduckgo.com?q=\(term)&format=json&pretty=1&no_html=1&skip_disambig=1")!
        
        let expectation = XCTestExpectation(description: "downloadResult")
        
        vm.downloadResult(for: termURL) { (DDGModel) in
            XCTAssertNil(DDGModel, "Error, \(term) was already searched before.")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let term: String = "Cat"
            
            let termURL: URL = URL(string: "https://api.duckduckgo.com?q=\(term)&format=json&pretty=1&no_html=1&skip_disambig=1")!
            
            vm.downloadResult(for: termURL, completion: { (DDGModel) in
                print("title: ",(DDGModel?.title)!)
            })
        }
    }

}

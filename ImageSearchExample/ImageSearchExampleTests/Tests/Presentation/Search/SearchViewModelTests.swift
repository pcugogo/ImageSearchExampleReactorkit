//
//  SearchViewModelTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
import Nimble

@testable import ImageSearchExample

final class SearchViewReactorTests: XCTestCase {
    
    var reactor: SearchViewReactor!
    let searchImageDummy = SearchImageDummy()
    let apiService = SearchAPIServiceSpy()
    
    override func setUp() {
        super.setUp()
        let coordinator = SearchCoordinator(navigationController: UINavigationController())
        let dependency = SearchCoordinator.Dependency(searchUseCase: SearchUseCase(apiService: apiService))
        reactor = SearchViewReactor(coordinator: coordinator,
                                        dependency: dependency)
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
    }
    
    func testSearchAction() {
        reactor.action.onNext(.search(keyword: "Test"))
        
        XCTAssertEqual(reactor.currentState.imageSections[0].items.count, searchImageDummy.totalCount)
        XCTAssertEqual(reactor.currentState.imageSections[0].items[0].displaySitename, "DummyTest0")
    }
    
    func testMoreFetch() {
        reactor.action.onNext(.search(keyword: "Test"))
        reactor.action.onNext(.loadNextPage)
        
        XCTAssertEqual(2, apiService.page)
        XCTAssertEqual(reactor.currentState.imageSections[0].items.count, searchImageDummy.totalCount * 2)
        XCTAssertEqual(reactor.currentState.imageSections[0].items[0].displaySitename, "DummyTest0")
    }
}

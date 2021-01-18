//
//  SearchViewModelTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import Nimble

@testable import ImageSearchExample

final class SearchViewReactorTests: XCTestCase {
    
    var reactor: SearchViewReactor!
    let searchImageDummy = SearchImageDummy()
    let apiService = SearchAPIServiceSpy()
    var searchRepository: SearchRepositoryType!
    
    override func setUp() {
        super.setUp()
        let coordinator = SearchCoordinator(root: UINavigationController())
        searchRepository = SearchRepository(apiService: apiService)
        let dependency = SearchCoordinator.Dependency(searchUseCase: SearchUseCase(imageSearchRepository: searchRepository))
        reactor = SearchViewReactor(
            coordinator: coordinator,
            dependency: dependency
        )
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
        
        guard let page = self.apiService.page else {
            XCTFail("SearchUseCase_currentPage counting error")
            return
        }
        
        XCTAssertEqual(2, page)
        
        XCTAssertEqual(
            reactor.currentState.imageSections[0].items.count,
            searchImageDummy.totalCount * 2
        )
        XCTAssertEqual(reactor.currentState.imageSections[0].items[0].displaySitename, "DummyTest0")
    }
}

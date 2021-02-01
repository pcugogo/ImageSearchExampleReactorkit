//
//  SearchViewModelTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import XCTest
import Nimble
import RxTest
import RxSwift
import RxCocoa
import SCoordinator


@testable import ImageSearchExample

final class SearchViewReactorTests: XCTestCase {
    
    var reactor: SearchViewReactor!
    let searchImageDummy = SearchImageDummy()
    let apiService = SearchAPIServiceSpy()
    var searchRepository: SearchRepositoryType!
    let scheduler = TestScheduler(initialClock: 0)
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        let coordinator = SearchCoordinator(root: UINavigationController())
        searchRepository = SearchRepository(apiService: apiService)
        let dependency = SearchCoordinator.Dependency(searchUseCase: SearchUseCase(searchRepository: searchRepository))
        reactor = SearchViewReactor(
            coordinator: coordinator,
            dependency: dependency
        )
    }
    
    func testFetchSearchData() {
        // Given
        let imagesSectionsIsEmpty = scheduler.createObserver(Bool.self)
        
        reactor.state.map { $0.imageSections }
            .map { $0.isEmpty }
            .bind(to: imagesSectionsIsEmpty)
            .disposed(by: disposeBag)
         
        // When
        scheduler.createColdObservable([.next(1, ("test"))])
            .bind { [weak self] in
                self?.reactor.action.onNext(.search(keyword: $0))
            }
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(2, Void())])
            .bind { [weak self] in
                self?.reactor.action.onNext(.loadNextPage)
            }
            .disposed(by: disposeBag)
        scheduler.start()
        
        // Then
        let recordedEvents = Recorded.events(
            .next(0, true),
            .next(1, false),
            .next(2, false)
        )
        XCTAssertEqual(imagesSectionsIsEmpty.events, recordedEvents)
    }
}

//
//  DetailImageModelTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 09/07/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import XCTest
import Nimble
import RxTest
import RxSwift
import RxCocoa

@testable import ImageSearchExample

final class DetailImageViewReactorTests: XCTestCase {
    
    var favoritesRepository: FavoritesRepositoryType!
    var reactor: DetailImageViewReactor!
    let searchImageDummy = SearchImageDummy()
    let scheduler = TestScheduler(initialClock: 0)
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        favoritesRepository = FavoritesRepository(favoritesStorage: FavoritesStorageFake())
        
        let dependency = DetailImageViewReactor.Dependency(
            imageURLString: searchImageDummy.imageURLString,
            fetchFavoritesUseCase: FetchFavoritesUseCase(favoritesRepository: favoritesRepository)
        )
        reactor = DetailImageViewReactor(
            coordinator: SearchCoordinator(root: UINavigationController()),
            dependency: dependency
        )
    }

    override func tearDown() {
        super.tearDown()
        print("tearDown")
    }

    func testUpdateFavorites() {
        // Given
        let isAddFavorites = scheduler.createObserver(Bool.self)
        
        reactor.state.map { $0.isAddFavorites }
            .bind(to: isAddFavorites)
            .disposed(by: disposeBag)
         
        // When
        scheduler.createColdObservable([.next(1, ()), .next(2, ())])
            .subscribe(onNext: { [weak self] _ in
                self?.reactor.action.onNext(.updateFavorites)
            })
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        let recordedEvents = Recorded.events(
            .next(0, false),
            .next(1, true),
            .next(2, false)
        )
        XCTAssertEqual(isAddFavorites.events, recordedEvents)
    }
}

//
//  DetailImageModelTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 09/07/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import Nimble

@testable import ImageSearchExample

final class DetailImageViewReactorTests: XCTestCase {
    var reactor: DetailImageViewReactor!
    let searchImageDummy = SearchImageDummy()
    
    override func setUp() {
        super.setUp()
        let dependency = DetailImageViewReactor.Dependency(
            imageURLString: searchImageDummy.imageURLString,
            fetchFavoritesUseCase: FetchFavoritesUseCase()
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
        reactor.action.onNext(.updateFavorites)
        XCTAssertEqual(reactor.currentState.isAddFavorites, true)
        reactor.action.onNext(.updateFavorites)
        XCTAssertEqual(reactor.currentState.isAddFavorites, false)
    }
}

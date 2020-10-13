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
        let coordinator = DetailImageCoordinator(navigationController: UINavigationController())
        let dependency = DetailImageCoordinator.Dependency(imageURLString: searchImageDummy.imageURLString,
                                               favoritesStorage: ImageFavoritesStorageFake())
        reactor = DetailImageViewReactor(coordinator: coordinator, dependency: dependency)
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

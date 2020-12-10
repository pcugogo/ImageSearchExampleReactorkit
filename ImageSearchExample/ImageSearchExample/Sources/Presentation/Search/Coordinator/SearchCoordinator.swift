//
//  SearchCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class SearchCoordinator: Coordinator {
    
    struct Dependency {
        let searchUseCase: SearchUseCaseType
    }
    
    func start(with dependency: Dependency) {
        let searchViewController = presenter.currentViewController as! SearchViewController
        let reactor = SearchViewReactor(coordinator: self, dependency: dependency)
        searchViewController.reactor = reactor
    }
    
    func navigate(to route: Route) {
        switch route {
        case .detailImage(let imageURLString):
            let coordinator = DetailImageCoordinator(presentStyle: presenter)
            let dependency = DetailImageCoordinator.Dependency(imageURLString: imageURLString,
                                                               favoritesStorage: ImageFavoritesStorage())
            coordinator.start(with: dependency)
        }
    }
}

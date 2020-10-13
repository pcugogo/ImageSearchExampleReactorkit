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
        let searchViewController = navigationController?.viewControllers.first as! SearchViewController
        let reactor = SearchViewReactor(coordinator: SearchCoordinator(navigationController: navigationController!),
                                        dependency: dependency)
        searchViewController.reactor = reactor
    }
    
    func navigate(to route: Route) {
        switch route {
        case .detailImage(let imageURLString):
            let coordinator = DetailImageCoordinator(navigationController: navigationController!)
            let dependency = DetailImageCoordinator.Dependency(imageURLString: imageURLString,
                                                   favoritesStorage: ImageFavoritesStorage())
            coordinator.start(with: dependency)
        }
    }
}


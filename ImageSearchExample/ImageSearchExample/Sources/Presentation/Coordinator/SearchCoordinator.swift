//
//  SearchCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit
import SCoordinator

final class SearchCoordinator: Coordinator<UINavigationController> {
    
    struct Dependency {
        let searchUseCase: SearchUseCaseType
    }
    
    func start(with dependency: Dependency) {
        let searchViewController = root.viewControllers.first as! SearchViewController
        let reactor = SearchViewReactor(coordinator: self, dependency: dependency)
        searchViewController.reactor = reactor
    }
    
    func navigate(to route: Route) {
        guard let searchRoute = route as? SearchRoute else { return }
        switch searchRoute {
        case .detailImage(let imageURLString):
            navigateToDetailImage(urlString: imageURLString)
        }
    }
}

extension SearchCoordinator {
    
    func navigateToDetailImage(urlString: String) {
        let dependency = DetailImageViewReactor.Dependency(
            imageURLString: urlString,
            favoritesStorage: ImageFavoritesStorage()
        )
        var detailImageViewController = DetailImageViewController.instantiateFromStoryboard()
        let reactor = DetailImageViewReactor(coordinator: self, dependency: dependency)
        detailImageViewController.reactor = reactor
        root.pushViewController(detailImageViewController, animated: true)
    }
}

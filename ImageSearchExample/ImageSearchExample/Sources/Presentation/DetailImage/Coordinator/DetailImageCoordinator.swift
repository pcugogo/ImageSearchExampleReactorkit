//
//  DetailImageCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class DetailImageCoordinator: Coordinator {
    
    struct Dependency {
        let imageURLString: String
        let favoritesStorage: ImageFavoritesStorageType
    }
    
    func start(with dependency: Dependency) {
        let reactor = DetailImageViewReactor(coordinator: self, dependency: dependency)
        let detailImageViewController = DetailImageViewController.instantiateFromStoryboard()
        detailImageViewController.reactor = reactor
        presenter.present(targetViewController: detailImageViewController)
    }
    
    func navigate(to route: Route) {}
}

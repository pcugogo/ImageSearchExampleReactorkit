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
        let storyboard = StoryboardName.main.instantiateStoryboard()
        let detailImageViewController = storyboard.instantiateViewController(withIdentifier:
            String(describing: DetailImageViewController.self)) as! DetailImageViewController
        detailImageViewController.reactor = reactor
        navigationController?.pushViewController(detailImageViewController, animated: true)
    }
    
    func navigate(to route: Route) {}
}

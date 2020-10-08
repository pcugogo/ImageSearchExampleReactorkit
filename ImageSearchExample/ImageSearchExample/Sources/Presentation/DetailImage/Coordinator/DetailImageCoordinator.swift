//
//  DetailImageCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

struct DetailImageDependency: Dependency {
    let imageURLString: String
    let favoritesStorage: ImageFavoritesStorageType
}

final class DetailImageCoordinator: Coordinator {
    
    func start(with dependency: DetailImageDependency) {
        let reactor = DetailImageViewReactor(coordinator: self, dependency: dependency)
        let storyboard = StoryboardName.main.instantiateStoryboard()
        let detailImageViewController = storyboard.instantiateViewController(withIdentifier:
            String(describing: DetailImageViewController.self)) as! DetailImageViewController
        detailImageViewController.reactor = reactor
        navigationController?.pushViewController(detailImageViewController, animated: true)
    }
    
    func navigate(to route: CoordinatorRoute) {}
}

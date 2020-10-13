//
//  DetailImageViewReactor.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/05/26.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import ReactorKit

final class DetailImageViewReactor: Reactor {
    enum Action {
        case updateFavorites
    }
    enum Mutation {
        case setUpdateFavorites(Bool)
    }
    struct State {
        let imageURLString: String
        var isAddFavorites: Bool
    }
    
    let initialState: State
    private let dependency: DetailImageCoordinator.Dependency
    
    init(coordinator: CoordinatorType, dependency: DetailImageCoordinator.Dependency) {
        self.dependency = dependency
        let imageURLString = dependency.imageURLString
        let isAddFavorites = dependency.favoritesStorage.isContains(imageURLString)
        self.initialState = State(imageURLString: imageURLString, isAddFavorites: isAddFavorites)
    }
}

extension DetailImageViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateFavorites:
            let imageURLString = dependency.imageURLString
            let isAddFavorites = dependency.favoritesStorage.update(imageURLString)
            return .just(Mutation.setUpdateFavorites(isAddFavorites))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setUpdateFavorites(let value):
            newState.isAddFavorites = value
        }
        return newState
    }
}

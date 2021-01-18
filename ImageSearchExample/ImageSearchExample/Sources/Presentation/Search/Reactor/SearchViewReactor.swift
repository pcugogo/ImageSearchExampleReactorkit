//
//  SearchViewReactor.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional
import RxDataSources
import ReactorKit
import SCoordinator

typealias ImagesSection = SectionModel<Void, ImageData>

final class SearchViewReactor: Reactor {
    
    struct Dependency {
        let searchUseCase: SearchUseCaseType
    }
    enum Action {
        case search(keyword: String)
        case loadNextPage
        case itemSeleted(imageURLString: String)
    }
    enum Mutation {
        case setSearch(imagesSection: [ImagesSection])
        case appendImagesCellItems([ImageData])
        case setErrorMessage(NetworkError)
    }
    struct State {
        var imageSections: [ImagesSection]
        var errorMessage: String?
    }
    
    let initialState: State = State(imageSections: [])
    
    private let dependency: Dependency
    private let coordinator: CoordinatorType
    
    init(coordinator: CoordinatorType, dependency: Dependency) {
        self.coordinator = coordinator
        self.dependency = dependency
    }
}

extension SearchViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .search(keyword):
            let result: Observable<Mutation> = dependency.searchUseCase
                .search(keyword: keyword)
                .map { .setSearch(imagesSection: [ImagesSection(model: Void(), items: $0.images)]) }
                .catchError { .just(Mutation.setErrorMessage($0 as? NetworkError ?? NetworkError.unknown)) }
            return result
        case .loadNextPage:
            guard !dependency.searchUseCase.isLastPage else {
                return Observable.empty()
            }
            let result: Observable<Mutation> = dependency.searchUseCase
                .loadMoreImages()
                .map { .appendImagesCellItems($0.images) }
                .catchError { .just(Mutation.setErrorMessage($0 as? NetworkError ?? NetworkError.unknown)) }
            return result
        case let .itemSeleted(imageURLString):
            coordinator.navigate(to: SearchRoute.detailImage(imageURLString: imageURLString))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSearch(let imagesSection):
            newState.imageSections = imagesSection
        case .appendImagesCellItems(let items):
            newState.imageSections[0].items += items
        case .setErrorMessage(let error):
            newState.errorMessage = error.message
        }
        return newState
    }
}

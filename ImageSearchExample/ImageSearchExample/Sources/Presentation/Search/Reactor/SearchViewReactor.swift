//
//  SearchViewReactor.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import RxDataSources
import ReactorKit

typealias ImagesSection = SectionModel<Void, ImageData>

final class SearchViewReactor: Reactor {
    
    enum Action {
        case search(keyword: String)
        case loadNextPage
        case itemSeleted(imageURLString: String)
    }
    enum Mutation {
        case setSearch(imagesSection: [ImagesSection])
        case appendImagesCellItems([ImageData])
        case setErrorMessage(String)
    }
    struct State {
        var imageSections: [ImagesSection]
        var errorMessage: String?
    }
    
    let initialState: State = State(imageSections: [])
    
    private let searchDependency: SearchDependency
    private let coordinator: CoordinatorType
    
    init(coordinator: CoordinatorType, dependency: Dependency) {
        self.coordinator = coordinator
        self.searchDependency = dependency as! SearchDependency
    }
}

extension SearchViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        let dependency = self.searchDependency
        switch action {
        case let .search(keyword):
            let keyword = Observable.just(keyword)
            let newSearch = keyword
                .flatMapLatest { dependency.searchUseCase.searchImage(keyword: $0) }
            return newSearch.map { result -> SearchViewReactor.Mutation in
                switch result {
                case .success(let response):
                    return .setSearch(imagesSection: [ImagesSection(model: Void(), items: response.images)])
                case .failure(let error):
                    return .setErrorMessage(error.reason)
                }
            }
        case .loadNextPage:
            guard !dependency.searchUseCase.isLastPage else {
                return Observable.empty()
            }
            let newSearch = Observable<Void>.just(Void())
                .flatMapLatest { _ in dependency.searchUseCase.loadMoreImage() }
            return newSearch.map { result -> SearchViewReactor.Mutation in
                switch result {
                case .success(let response):
                    return .appendImagesCellItems(response.images)
                case .failure(let error):
                    return .setErrorMessage(error.reason)
                }
            }
        case let .itemSeleted(imageURLString):
            coordinator.navigate(to: .detailImage(imageURLString: imageURLString))
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
        case .setErrorMessage(let message):
            newState.errorMessage = message
        }
        return newState
    }
}

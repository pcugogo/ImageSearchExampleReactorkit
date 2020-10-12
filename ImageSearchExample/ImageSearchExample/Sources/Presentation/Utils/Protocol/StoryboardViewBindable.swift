//
//  StoryboardViewBindable.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/10/12.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import ReactorKit

protocol StoryboardViewBindable: StoryboardView {
    associatedtype Reactor
    
    func bindAction(_ reactor: Reactor)
    func bindState(_ reactor: Reactor)
}
extension StoryboardViewBindable {
    func bind(reactor: Reactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

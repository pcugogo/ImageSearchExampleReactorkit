//
//  SearchViewController.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxOptional
import RxDataSources
import ReactorKit

final class SearchViewController: UIViewController, StoryboardView {
    
    typealias ImagesDataSource = RxCollectionViewSectionedReloadDataSource<ImagesSection>
    
    var disposeBag = DisposeBag()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        return searchController
    }()
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    private let imagesDataSource = ImagesDataSource(configureCell: { _, collectionView, indexPath, data in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionViewCell.self),
                                                            for: indexPath) as? ImageCollectionViewCell else {
                                                                fatalError()
        }
        cell.setImage(urlString: data.imageURL)
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(reactor: SearchViewReactor) {
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
            .filterEmpty()
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.searchController.dismiss(animated: true, completion: nil)
            })
            .map { Reactor.Action.search(keyword: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let itemsCount = reactor.state.map { $0.imageSections }
            .filter { !$0.isEmpty }
            .map { $0[0].items.count }
        
        imagesCollectionView.rx.willDisplayCell.withLatestFrom(itemsCount, resultSelector: { ($0.at, $1) })
            .map({ (indexPath, itemsCount) -> Bool in
                return itemsCount != 1 && itemsCount - 1 == indexPath.item
            })
            .filter { $0 }
            .throttle(.milliseconds(700), latest: false, scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        imagesCollectionView.rx.itemSelected.withLatestFrom(
            reactor.state,
            resultSelector: { ($0, $1.imageSections) }
        )
            .map { Reactor.Action.itemSeleted(imageURLString: $1[0].items[$0.item].imageURL) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.imageSections }
            .bind(to: imagesCollectionView.rx.items(dataSource: imagesDataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .filterNil()
            .subscribe { [weak self] message in
                self?.showAlert("네트워크 오류", message.element!)
        }
        .disposed(by: disposeBag)
    }
}

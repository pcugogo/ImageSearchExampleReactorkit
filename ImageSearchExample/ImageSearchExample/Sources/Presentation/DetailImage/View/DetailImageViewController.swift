//
//  DetailImageViewController.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/05/18.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

//
//  DetailImageViewController.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/05/18.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import ReactorKit

final class DetailImageViewController: UIViewController, StoryboardView {
    
    var disposeBag: DisposeBag = .init()
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension DetailImageViewController {
    func bind(reactor: DetailImageViewReactor) {
        favoriteButton.rx.tap
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateFavorites }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.imageURLString }
            .subscribe(onNext: { [weak self] in
                guard let self = self, let url = URL(string: $0) else { return }
                self.detailImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isAddFavorites }
            .bind(to: favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}

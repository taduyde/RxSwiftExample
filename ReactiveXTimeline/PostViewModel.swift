//
//  PostViewModel.swift
//  ReactiveXTimeline
//
//  Created by Ta Duy De on 4/22/17.
//  Copyright © 2017 Ta Duy De. All rights reserved.
//

import RxSwift
import RxCocoa

final class PostViewModel {
    
    private let service: PostAPIService
    
    init(service: PostAPIService) {
        self.service = service
    }
    
    func getPosts(searchText: String) -> Observable<[Post]> {
        return service.getPosts(searchText: searchText).map { $0.sorted(by: { $0.title < $1.title })  }
    }
}

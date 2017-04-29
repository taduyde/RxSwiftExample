//
//  PostAPIService.swift
//  ReactiveXTimeline
//
//  Created by Ta Duy De on 4/22/17.
//  Copyright © 2017 Ta Duy De. All rights reserved.
//

import RxSwift
import RxCocoa

final class PostAPIService: BaseAPIService {
    
    func testService() {
        print("Ok======>")
    }
    
    func getPosts(searchText: String) -> Observable<[Post]> {
        let lowerSearchText = searchText.lowercased()
        return rx_requestArray(url: "https://jsonplaceholder.typicode.com/posts").map {
            searchText.isEmpty ? $0 : $0.filter { $0.title.contains(lowerSearchText) }
        }
    }
    
    func getPostDetail(id: String) -> Observable<Post> {
        return rx_requestObject(url: "https://jsonplaceholder.typicode.com/posts/\(id)")
    }
}

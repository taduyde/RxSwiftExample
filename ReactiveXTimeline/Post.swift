//
//  Post.swift
//  ReactiveXTimeline
//
//  Created by Ta Duy De on 4/22/17.
//  Copyright © 2017 Ta Duy De. All rights reserved.
//

final class Post: JSONDecodable {
    let userId: String
    let id: String
    let title: String
    let body: String?
    
    init(dict: [String : AnyObject]) throws {
        userId = dict["userid"] as? String ?? ""
        id = dict["id"] as? String ?? ""
        title = dict["title"] as? String ?? ""
        body = dict["body"] as? String
    }
}

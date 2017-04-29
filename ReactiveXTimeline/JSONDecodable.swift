//
//  JSONDecodable.swift
//  ReactiveXTimeline
//
//  Created by Ta Duy De on 4/22/17.
//  Copyright © 2017 Ta Duy De. All rights reserved.
//

protocol JSONDecodable {
    init(dict: [String: AnyObject]) throws
}

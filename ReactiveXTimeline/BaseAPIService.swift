//
//  BaseAPIService.swift
//  ReactiveXTimeline
//
//  Created by Ta Duy De on 4/22/17.
//  Copyright © 2017 Ta Duy De. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire

enum ServiceError: Error {
    case invalidJSON
}

typealias JSON = [String: AnyObject]

class BaseAPIService {
    func rx_requestArray<T: JSONDecodable>(url: String) -> Observable<[T]> {
        return rx_requestJSON(url: url).map{ try $0.flatMap { try T.init(dict: $0) } }
    }
    
    func rx_requestObject<T: JSONDecodable>(url: String) -> Observable<T> {
        return rx_requestJSON(url: url).map { try T.init(dict: $0.first!)}
    }
    
    func rx_requestJSON(url: String) -> Observable<[JSON]> {
        return Observable.create({ o -> Disposable in
            let request = Alamofire.request(url)
                        .validate(statusCode: 200...300)
                        .validate(contentType: ["application/json"])
            request.responseJSON { data in
                guard data.result.error == nil, let json = data.result.value as? [JSON] else {
                    o.onError(data.result.error ?? ServiceError.invalidJSON)
                    o.onCompleted()
                    return
                }
                o.onNext(json)
                o.onCompleted()
            }
            return Disposables.create {
                request.cancel()
            }
        })
    }
}

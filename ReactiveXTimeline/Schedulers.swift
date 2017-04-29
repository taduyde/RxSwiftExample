//
//  Schedulers.swift
//  ReactiveXTimeline
//
//  Created by Ta Duy De on 4/24/17.
//  Copyright © 2017 Ta Duy De. All rights reserved.
//

import RxCocoa
import RxSwift

struct Schedulers {
    static var main: SchedulerType {
        return MainScheduler.instance
    }
    
    //    static let backgroundDefault: SchedulerType = {
    //        return ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .background)
    //    }()
    //
    //    static let backgroundUserInitiated: SchedulerType = {
    //        return ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .userInitiated)
    //    }()
}

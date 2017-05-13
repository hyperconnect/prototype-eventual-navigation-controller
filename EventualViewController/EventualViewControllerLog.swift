//
//  EventualViewControllerLog.swift
//  EventualViewController
//
//  Created by Hoon H. on 2017/05/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

struct EventualViewControllerLog {
    static func testAndLogWarningOnFailure(_ cond: @autoclosure () -> Bool, _ message: @autoclosure () -> String) {
        if cond() == false {
            logWarning(message())
        }
    }
    static func logWarning(_ s: String) {

    }
}

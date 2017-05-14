//
//  TransitionSafetyQuery.swift
//  EventualViewController
//
//  Created by Hoon H. on 2017/05/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

public protocol TransitionSafetyQuery: class {
    @nonobjc
    var isSafeToParticipateInTransition: Bool { get }
    @nonobjc
    var isSafeToPresentModal: Bool { get }
    @nonobjc
    var isSafeToDismissModal: Bool { get }
}

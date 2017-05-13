//
//  TSQNavigationController.swift
//  EventualViewController
//
//  Created by Hoon H. on 2017/05/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import UIKit

class TSQNavigationController: UINavigationController, TransitionSafetyQuery {
    private var appearingState = TSQAppearingState.disappeared

    var isSafeToParticipateInTransition: Bool {
//        guard isBeingPresented == false else { return false }
//        guard isBeingDismissed == false else { return false }
//        guard isMovingToParentViewController == false else { return false }
//        guard isMovingFromParentViewController == false else { return false }
        guard transitionCoordinator == nil else { return false }
        switch appearingState {
        case .appeared, .disappeared:
            for vc in viewControllers {
                let vc = vc as! TransitionSafetyQuery
                guard vc.isSafeToParticipateInTransition else { return false }
            }
            return true
        case .appearing, .disappearing:
            return false
        }
    }
    var isSafeToPresentModal: Bool {
        guard presentedViewController == nil else { return false }
        return isSafeToParticipateInTransition
    }
    var isSafeToDismissModal: Bool {
        guard let vc = presentedViewController else { return false }
        guard vc.presentedViewController == nil else { return false }
        return isSafeToParticipateInTransition
    }

    override func viewWillAppear(_ animated: Bool) {
        appearingState = .appearing
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appearingState = .appeared
    }
    override func viewWillDisappear(_ animated: Bool) {
        appearingState = .disappearing
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appearingState = .disappeared
    }
}

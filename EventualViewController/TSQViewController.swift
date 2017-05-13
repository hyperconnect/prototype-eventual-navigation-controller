//
//  TSQViewController.swift
//  EventualViewController
//
//  Created by Hoon H. on 2017/05/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import UIKit

class TSQViewController: UIViewController, TransitionSafetyQuery {
    private var appearingState = TSQAppearingState.disappeared

    var isSafeToParticipateInTransition: Bool {
        switch appearingState {
        case .appeared, .disappeared:
            return true
        case .appearing, .disappearing:
            return false
        }
    }
    var isSafeToPresentModal: Bool {
        guard presentingViewController == nil else { return false }
        return isSafeToParticipateInTransition
    }
    var isSafeToDismissModal: Bool {
        guard let vc = presentedViewController else { return false }
        guard vc.presentedViewController == nil else { return false }
        return true
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

//
//  TSQAlertController.swift
//  EventualViewController
//
//  Created by Hoon H. on 2017/05/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import UIKit

class TSQAlertController: UIAlertController, TransitionSafetyQuery {
    private var appearingState = TSQAppearingState.disappeared

    var isSafeToParticipateInTransition: Bool {
        guard transitionCoordinator == nil else { return false }
        switch appearingState {
        case .appeared, .disappeared:
            return true
        case .appearing, .disappearing:
            return false
        }
    }
    var isSafeToPresentModal: Bool {
        return false
    }
    var isSafeToDismissModal: Bool {
        return false
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

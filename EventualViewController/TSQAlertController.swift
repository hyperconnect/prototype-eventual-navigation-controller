//
//  TSQAlertController.swift
//  EventualViewController
//
//  Created by Hoon H. on 2017/05/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import UIKit

public class TSQAlertController: UIAlertController, TransitionSafetyQuery {
    private var appearingState = TSQAppearingState.disappeared

    public var isSafeToParticipateInTransition: Bool {
        guard transitionCoordinator == nil else { return false }
        switch appearingState {
        case .appeared, .disappeared:
            return true
        case .appearing, .disappearing:
            return false
        }
    }
    public var isSafeToPresentModal: Bool {
        return false
    }
    public var isSafeToDismissModal: Bool {
        return false
    }

    public override func viewWillAppear(_ animated: Bool) {
        appearingState = .appearing
        super.viewWillAppear(animated)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appearingState = .appeared
    }
    public override func viewWillDisappear(_ animated: Bool) {
        appearingState = .disappearing
        super.viewWillDisappear(animated)
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appearingState = .disappeared
    }
}

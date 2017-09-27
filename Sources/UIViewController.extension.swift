//
//  UIViewController.extension.swift
//  EventualViewController
//
//  Created by Hoon H. on 2017/05/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var rootViewController: UIViewController {
        if let vc = presentingViewController {
            return vc.rootViewController
        }
        if let vc = parent {
            return vc.rootViewController
        }
        return self
    }
}

extension UIViewController: TransitionSafetyQuery {
    public var isSafeToParticipateInTransition: Bool {
//        guard isBeingPresented == false else { return false }
//        guard isBeingDismissed == false else { return false }
//        guard isMovingToParentViewController == false else { return false }
//        guard isMovingFromParentViewController == false else { return false }
        guard transitionCoordinator == nil else { return false }
        for vc in childViewControllers {
            guard vc.isSafeToParticipateInTransition else { return false }
        }
        return true
    }
    public var isSafeToPresentModal: Bool {
        guard presentedViewController == nil else { return false }
        return isSafeToParticipateInTransition
    }
    public var isSafeToDismissModal: Bool {
        guard let vc = presentedViewController else { return false }
        guard vc.presentedViewController == nil else { return false }
        return isSafeToParticipateInTransition
    }

}

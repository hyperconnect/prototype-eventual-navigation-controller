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
    var isSafeToParticipateInTransition: Bool {
        //
        // A `UIAlertController` never returns proper result for these properties.
        // - `isBeingPresented`. (always `false`)
        // - `isBeingDismissed`. (always `false`)
        // - `UIApplication.shared.isIgnoringInteractionEvents` (returns `false`).
        // Therefore, it's impossible to avoid in-animation state with these
        // properties for alerts.
        // Also, these hack methods doesn't work either.
        // - `view.layer.presentation()` (always non-`nil`)
        //
        // The only way to get safe time to perform transition is checking for
        // `transitionCoordinator`.
        //
        // This can print a warning about navigation-bar breakage like this
        // if you make `UINavigationController.viewController == []`.
        // Always `UINavigationController` to have some view-controllers.
        // Empty children is actually an error state.
        //
        guard transitionCoordinator == nil else { return false }
//        guard isBeingPresented == false else { return false }
//        guard isBeingDismissed == false else { return false }
//        guard isMovingToParentViewController == false else { return false }
//        guard isMovingFromParentViewController == false else { return false }
        for vc in childViewControllers {
            guard vc.isSafeToParticipateInTransition else { return false }
        }
        if let p = presentedViewController {
            guard p.isSafeToParticipateInTransition else { return false }
        }
        return true
    }
    var isSafeToPresentModal: Bool {
        guard presentedViewController == nil else { return false }
        return rootViewController.isSafeToParticipateInTransition
    }
    var isSafeToDismissModal: Bool {
        guard let vc = presentedViewController else { return false }
        guard vc.presentedViewController == nil else { return false }
        return rootViewController.isSafeToParticipateInTransition
    }
}

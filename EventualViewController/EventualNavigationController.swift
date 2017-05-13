//
//  EventualNavigationController.swift
//  EventualViewController
//
//  Created by Hoon H. on 2017/05/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import UIKit

class EventualNavigationController: TSQNavigationController {
    private let loopDevice = EventualViewControllerLoopDevice()
    private var userInteractionBlocker: EventualViewControllerUserInteractionBlocker?

    var state = State() {
        didSet { loopDevice.isRunning = true }
    }

    ///
    /// User interaction will be disabled until all queued states
    /// to be consumed.
    ///
    var queue = [State]() {
        didSet { loopDevice.isRunning = true }
    }

    struct State: Equatable {
        var modal: UIViewController?
        var stack = [UIViewController]()

        static func == (_ a: State, _ b: State) -> Bool {
            return a.modal === b.modal && a.stack == b.stack
        }
    }

//    func scanState() -> State {
//        return .init(modal: presentedViewController, stack: Array(viewControllers.dropFirst()))
//    }

    private func isArrivedToState() -> Bool {
        return presentedViewController === state.modal && Array(viewControllers.dropFirst()) == state.stack
    }
    private func step() {
        userInteractionBlocker = (userInteractionBlocker ?? EventualViewControllerUserInteractionBlocker())
        while isArrivedToState() {
            if let f = queue.first {
                queue.removeFirst()
                state = f
            }
            else {
                loopDevice.isRunning = false
                userInteractionBlocker = nil
                return
            }
        }

        guard rootViewControllerSafetyQuery.isSafeToParticipateInTransition else { return }
        if state.modal !== presentedViewController {
            if let vc = presentedViewController {
                EventualViewControllerLog.testAndLogWarningOnFailure(vc.presentingViewController == self, "There's a modal VC presented by other VC... Waiting for the VC to be dismissed...")
                guard vc.presentingViewController == self else { return }
                if isSafeToDismissModal {
                    dismiss(animated: true, completion: nil)
                    return
                }
            }
            if let vc = state.modal {
                guard view.window != nil else { return }
                if isSafeToPresentModal {
                    present(vc, animated: true, completion: nil)
                    return
                }
            }
        }
        if state.stack != Array(viewControllers.dropFirst()) {
            setViewControllers([viewControllers[0]] + state.stack, animated: true)
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loopDevice.step = { [weak self] in self?.step() }
    }
}

private final class EventualViewControllerUserInteractionBlocker {
    init() {
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    deinit {
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

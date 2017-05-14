//
//  EventualNavigationController.swift
//  EventualViewController
//
//  Created by Hoon H. on 2017/05/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import UIKit

public class EventualNavigationController: TSQNavigationController {
    private let loopDevice = EventualViewControllerLoopDevice()
    private var userInteractionBlocker: EventualViewControllerUserInteractionBlocker?

    ///
    /// User interaction becomes disabled until all queued states
    /// to be consumed.
    ///
    public var queue = [State]() {
        didSet { resumeSyncLoop() }
    }

    public struct State: Equatable {
        public var modal: UIViewController?
        public var stack = [UIViewController]()
        public init() {}
        public init(modal: UIViewController?, stack: [UIViewController]) {
            assert(modal == nil || modal! is TransitionSafetyQuery)
            assert(stack.map({ $0 is TransitionSafetyQuery }).reduce(true, { $0 && $1 }))
            self.modal = modal
            self.stack = stack
        }
        public static func == (_ a: State, _ b: State) -> Bool {
            return a.modal === b.modal && a.stack == b.stack
        }
    }

    ///
    /// Make and return navigation state by scanning current view state. 
    ///
    public func scan() -> State {
        return .init(modal: presentedViewController, stack: Array(viewControllers.dropFirst()))
    }



    private func hasArrivedToFinalState() -> Bool {
        guard let fs = queue.first else { return true }
        return scan() == fs
    }

    private func pauseSyncLoop() {
        loopDevice.isRunning = false
    }
    private func resumeSyncLoop() {
        loopDevice.isRunning = true
    }
    private func stepSyncLoop() {
        userInteractionBlocker = (userInteractionBlocker ?? EventualViewControllerUserInteractionBlocker())
        while hasArrivedToFinalState() {
            guard queue.first != nil else {
                pauseSyncLoop()
                userInteractionBlocker = nil
                return
            }
            queue.removeFirst()
        }
        guard let state = queue.first else { return }

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

    public override func viewDidLoad() {
        super.viewDidLoad()
        loopDevice.step = { [weak self] in self?.stepSyncLoop() }
    }
}

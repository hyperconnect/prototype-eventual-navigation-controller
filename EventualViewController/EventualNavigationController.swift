//
//  EventualNavigationController.swift
//  EventualViewController
//
//  Created by Hoon H. on 2017/05/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import UIKit

///
/// - Note:
///     Take care that "0-view-controller in stack" is an abnormal
///     state for an NC, so it won't give you proper animations.
///     Anyway, it still work with no breakage.
///
public class EventualNavigationController: UINavigationController {
    private let loopDevice = LoopDevice()
    private var userInteractionBlocker: UserInteractionEventBlocker?

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
        return .init(modal: presentedViewController, stack: viewControllers)
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
        userInteractionBlocker = (userInteractionBlocker ?? UserInteractionEventBlocker())
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
                LogDevice.testAndLogWarningOnFailure(vc.presentingViewController == self, "There's a modal VC presented by other VC... Waiting for the VC to be dismissed...")
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
        if state.stack != viewControllers {
            setViewControllers(state.stack, animated: true)
            return
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        loopDevice.step = { [weak self] in self?.stepSyncLoop() }
    }
}

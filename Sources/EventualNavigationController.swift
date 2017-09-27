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
/// Provides eventual navigation by state sequence.
///
/// You set `queue` as you want, and this object will navigate
/// sequentially through for each state in the queue with animations.
///
/// Switching to another state is done in single animation. For example,
/// if you have 4 view-controllers in navigation-stack and next state has
/// only 1, three view-controllers will be popped out in an animation.
/// You can push three states to the `queue` if you want three-step animations.
///
/// User interaction becomes disabled until all queued states
/// to be consumed.
///
/// You can query current state from this object if needed.
///
/// - Note:
///     UIKit does not support presentation and dismission of multiple
///     modal view-controller at once with animation. It seems to be an
///     intentional design, and I don't want to try to work around this.
///     So this object cannot support presentation of multiple modal
///     VCs in one-step. You are recommended to stack multiple instances of
///     `EventualNavigationController` to present multiple modal VCs.
///
/// - Note:
///     NC allows push/pop while a modal VC is presented.
///
/// - Note:
///     Take care that "0-view-controller in stack" is an abnormal
///     state for an NC, so it won't give you proper animations.
///     Anyway, it still work with no breakage.
///
open class EventualNavigationController: UINavigationController {
    private let loopDevice = LoopDevice()
    private var userInteractionBlocker: InteractionEventBlocker?

    ///
    /// Sequence of planned states to navigate through.
    ///
    /// You can set this property at any time.
    ///
    open var queue = [State]() {
        didSet { resumeSyncLoop() }
    }

    public struct State: Equatable {
        public var modal: UIViewController?
        public var navigation = [UIViewController]()
        public init() {}
        public init(modal: UIViewController?, navigation: [UIViewController]) {
            assertNonEmptyNavigationStack(navigation)
            self.modal = modal
            self.navigation = navigation
        }
        public static func == (_ a: State, _ b: State) -> Bool {
            return a.modal === b.modal && a.navigation == b.navigation
        }
    }






    ///
    /// Make and return navigation state by scanning current view state. 
    ///
    open func scan() -> State {
        return .init(modal: presentedViewController, navigation: viewControllers)
    }



    private func hasArrivedToFirstState() -> Bool {
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
        assertNonEmptyNavigationStack(viewControllers)
        userInteractionBlocker = (userInteractionBlocker ?? InteractionEventBlocker())
        while hasArrivedToFirstState() {
            if queue.isEmpty {
                pauseSyncLoop()
                userInteractionBlocker = nil
                return
            }
            queue.removeFirst()
        }
        guard let state = queue.first else { return }

        guard rootViewController.isSafeToParticipateInTransition else { return }
        if state.modal !== presentedViewController {
            if let vc = presentedViewController {
                assert(vc.presentingViewController == self, "There's a modal VC presented by other VC... Waiting for the VC to be dismissed... This is information to alert you this waiting...")
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
        if state.navigation != viewControllers {
            setViewControllers(state.navigation, animated: true)
            return
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        loopDevice.step = { [weak self] in self?.stepSyncLoop() }
    }

}

private func assertNonEmptyNavigationStack(_ viewControllers: @autoclosure () -> [UIViewController]) {
    assert(viewControllers().isEmpty == false, "Empty navigation stack may can produce view layout corruption. Do not make it empty.")
}


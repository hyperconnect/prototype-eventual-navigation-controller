////
////  EventualViewController.swift
////  EventualViewController
////
////  Created by Hoon H. on 2017/05/14.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import Foundation
//import UIKit
//
/////
///// - Note:
/////     Plain VC does not provide modal VC presentation.
/////     It's because,
/////     - Usually it has no benefit.
/////       Because actually NC present the modals.
/////     - The only thing it should present is alerts. 
/////       Which will be handled by NC.
/////     - Increases complexity.
/////
//final class EventualViewController: TSQViewController {
//}
//
////final class EventualViewController: UIViewController, TSQ {
////    private let loopDevice = EventualViewControllerLoopDevice()
////    private var appearingState = TSQAppearingState.disappeared
////
////    var state = State()
////    var queue = [State]()
////
////    struct State: Equatable {
////        var modal: UIViewController?
////
////        static func == (_ a: State, _ b: State) -> Bool {
////            return a.modal === b.modal
////        }
////    }
////
////    var isSafeToParticipateInTransition: Bool {
////        switch appearingState {
////        case .appeared, .disappeared:
////            return true
////        case .appearing, .disappearing:
////            return false
////        }
////    }
////    var isSafeToPerformModalTransition: Bool {
////        guard transitionCoordinator == nil else { return false }
////        if let vc = presentedViewController {
////            let vc = vc as! TSQ
////            return vc.isSafeToParticipateInTransition
////        }
////        else {
////            return isSafeToParticipateInTransition
////        }
////    }
////
////    private func isArrivedToState() -> Bool {
////        return presentedViewController === state.modal
////    }
////    private func step() {
////        while isArrivedToState() {
////            if let f = queue.first {
////                queue.removeFirst()
////                state = f
////            }
////            else {
////                return
////            }
////        }
////
////        guard rootViewControllerSafetyQuery.isSafeToParticipateInTransition else { return }
////        guard isSafeToPerformModalTransition else { return }
////        if state.modal !== presentedViewController {
////            if let vc = presentedViewController {
////                EventualViewControllerLog.testAndLogWarningOnFailure(vc.presentingViewController == self, "There's a modal VC presented by other VC... Waiting for the VC to be dismissed...")
////                guard vc.presentingViewController == self else { return }
////                dismiss(animated: true, completion: nil)
////                return
////            }
////            if let vc = state.modal {
////                guard view.window != nil else { return }
////                present(vc, animated: true, completion: nil)
////                return
////            }
////        }
////    }
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        loopDevice.step = { [weak self] in self?.step() }
////    }
////    override func viewWillAppear(_ animated: Bool) {
////        appearingState = .appearing
////        super.viewWillAppear(animated)
////    }
////    override func viewDidAppear(_ animated: Bool) {
////        super.viewDidAppear(animated)
////        appearingState = .appeared
////    }
////    override func viewWillDisappear(_ animated: Bool) {
////        appearingState = .disappearing
////        super.viewWillDisappear(animated)
////    }
////    override func viewDidDisappear(_ animated: Bool) {
////        super.viewDidDisappear(animated)
////        appearingState = .disappeared
////    }
////}

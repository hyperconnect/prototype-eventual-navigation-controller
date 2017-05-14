//
//  LoopDevice.swift
//  EventualViewController
//
//  Created by Hoon H. on 2017/05/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import UIKit

final class LoopDevice {
    private let pr = Proxy()
    private let dl: CADisplayLink
    var step: () -> Void = {}
    var isRunning = false {
        didSet { apply() }
    }

    init() {
        dl = CADisplayLink(target: pr, selector: #selector(Proxy.EVC_processDisplaySyncSignal(_:)))
        pr.delegate = { [weak self] in self?.processDisplaySyncSignal() }
        dl.add(to: .main, forMode: .commonModes)
    }
    deinit {
        dl.invalidate()
    }

    private func processDisplaySyncSignal() {
        step()
    }
    private func apply() {
        dl.isPaused = (isRunning == false)
    }

    @objc
    private final class Proxy: NSObject {
        @nonobjc
        var delegate: (() -> Void)?
        @objc
        func EVC_processDisplaySyncSignal(_: AnyObject) {
            delegate?()
        }
    }
}

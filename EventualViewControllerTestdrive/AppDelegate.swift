//
//  AppDelegate.swift
//  EventualViewControllerTestdrive
//
//  Created by Hoon H. on 2017/05/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import UIKit
import EventualViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let w = UIWindow(frame: UIScreen.main.bounds)
    private let nc = EventualNavigationController(rootViewController: UIViewController())
    private let vc1 = UIViewController()
    private let ac2 = UIAlertController(title: "AC2", message: "22", preferredStyle: .alert)
    private let vc3 = UIViewController()
    private let ac4 = UIAlertController(title: "AC4", message: "4444", preferredStyle: .alert)

    private let nc5 = EventualNavigationController()
    private let ac6 = UIAlertController(title: "AC6", message: "666666", preferredStyle: .alert)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        vc1.view.backgroundColor = .red
        vc3.view.backgroundColor = .green
        nc5.view.backgroundColor = UIColor.blue.withAlphaComponent(1)

        w.makeKeyAndVisible()
        w.rootViewController = nc

        nc.queue = [
            .init(modal: ac2, stack: []),
            .init(modal: ac2, stack: [vc1]),
            .init(modal: ac2, stack: [vc1, vc3]),
            .init(modal: ac2, stack: []),
            .init(modal: nil, stack: [vc3]),
            .init(modal: nc5, stack: [vc3, vc1]),
            .init(modal: nil, stack: [vc3, vc1]),
            .init(modal: nil, stack: [vc3]),
            .init(modal: nil, stack: []),
        ]

//        weak var ss = self
//        let calls = { n in DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(n)) { ss?.step(n) } } as (Int) -> Void
//        calls(0)
//        calls(1)
//        calls(2)
//        calls(3)
//        calls(4)

        return true
    }

    private func step(_ n: Int) {
        switch n {
        case 0:
            break
        case 1:
            nc5.queue = [.init(modal: ac6, stack: [])]
            break
        case 2:
            break
        case 3:
            break
        case 4:
            nc5.queue = [.init(modal: nil, stack: [])]
            break

        default:
            preconditionFailure()
        }
    }
}

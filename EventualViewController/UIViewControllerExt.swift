//
//  UIViewControllerExt.swift
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
    var rootViewControllerSafetyQuery: TransitionSafetyQuery {
        return rootViewController as! TransitionSafetyQuery
    }
}


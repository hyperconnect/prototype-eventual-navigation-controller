//
//  InteractionEventBlocker.swift
//  EventualViewController
//
//  Created by Hoon H. on 2017/05/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import UIKit

final class InteractionEventBlocker {
    init() {
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    deinit {
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

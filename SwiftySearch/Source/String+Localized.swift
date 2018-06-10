//
//  String + Localized.swift
//  JSONPratice
//
//  Created by Vincent Lin on 2018/6/9.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}

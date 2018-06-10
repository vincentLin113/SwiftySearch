//
//  SwiftySearch + Width.swift
//  JSONPratice
//
//  Created by Vincent Lin on 2018/6/9.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit


public extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        #if swift(>=4.0)
        let fontAttributes = [kCTFontAttributeName: font]
        let size = self.size(withAttributes: fontAttributes as [NSAttributedStringKey : Any])
        return size.width
        #else
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
        #endif
    }
}

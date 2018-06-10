//
//  WithoutCancelSearchBar.swift
//  Job1111
//
//  Created by Vincent Lin on 16/04/2018.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit

class WithoutCancelSearchBar: UISearchBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShowsCancelButton(false, animated: false)
    }
}

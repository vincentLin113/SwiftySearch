//
//  WithoutCancelSearchController.swift
//  Job1111
//
//  Created by Vincent Lin on 16/04/2018.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit

class WithoutCancelSearchController: UISearchController, UISearchBarDelegate {
    
    lazy var _searchBar: WithoutCancelSearchBar = {
        [unowned self] in
        let result = WithoutCancelSearchBar(frame: .zero)
        result.delegate = self
        
        return result
        }()
    
    override var searchBar: UISearchBar {
        get {
            return _searchBar
        }
    }
}

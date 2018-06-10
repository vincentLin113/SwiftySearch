//
//  StyleHighlightCellCustom.swift
//  Job1111
//
//  Created by Vincent Lin on 15/04/2018.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit

public struct StyleHighlightCellCustom {
    
    /**
     是否要Show selectedBackgroundView, default = true
     */
    public static var isShowSelectionBackgroundView: Bool = true
    
    /**
     highlight狀態下的顏色, default : UIColor.Blue.mainBlue
     */
    public static var highlightColor: UIColor = UIColor.Blue.mainBlue
    
    /**
     highlight狀態下 特效view的alpha, default : 0.1
     */
    public static var highlightViewAlpha: CGFloat = 0.1
    
    
    /**
     highlight狀態下 leftBarView的寬, default : 3.0
     */
    public static var barWidth: CGFloat = 3.0
    
    
    /**
     highlight狀態下 leftBarView的上空隙, default : 0.0
     */
    public static var barTopSpace: CGFloat = 0.0
    
    
    /**
     highlight狀態下 leftBarView的底空隙, default : 0.0
     */
    public static var barBottomSpace: CGFloat = 0.0
    
    
    /**
     highlight狀態下 leftBarView的左空隙, default : 0.0
     */
    public static var barLeftSpace: CGFloat = 0.0
}

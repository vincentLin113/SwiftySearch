//
//  SwiftySearchCustom.swift
//  JSONPratice
//
//  Created by Vincent Lin on 2018/6/9.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit


public struct SwiftySearchCustom {
    
    /**
     SearchBar cursor顏色
     rgb(56, 159, 238)
     */
    public static var cursorColor: UIColor = UIColor.Blue.mainBlue
    
    /**
     search record optionButton border color, defalt : UIColor.Blue.mainBlue
     */
    public static var searchRecordOptionButtonBorderColor: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
    
    /**
     search record optionButton text color, defalt : UIColor.Blue.mainBlue
     */
    public static var searchRecordOptionButtonTextColor: UIColor = UIColor.darkText
    
    /**
     hot search optionButton border color, defalt : UIColor.Blue.mainBlue
     */
    public static var hotSearchOptionButtonBorderColor: UIColor = UIColor.Blue.mainBlue
    
    
    /**
     hot search optionButton text color, defalt : UIColor.Blue.mainBlue
     */
    public static var hotSearchOptionButtonTextColor: UIColor = UIColor.Blue.mainBlue
    
    /**
     交換上下順序
     若為false, 搜尋紀錄在上面
     */
    public static var swapSearchRecordWithHotSearch: Bool = false
    
    
}

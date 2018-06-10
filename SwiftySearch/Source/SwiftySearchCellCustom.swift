//
//  SwiftySearchCellCustom.swift
//  JSONPratice
//
//  Created by Vincent Lin on 2018/6/9.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit

let bundle = Bundle.init(for: SwiftySearchController.self)

public struct SwiftySearchCellCustom {
    
    /**
     是否show cleanButton
     根據常理, 熱門關鍵字不需要清除紐
     */
    public static var isHiddenCleanButton: Bool = false
    
    /**
     titleView's height '預設50.0'
     */
    public static var textViewHeight: CGFloat = 50.0
    
    /**
     客製化背景顏色 預設 UIColor.white
     */
    public static var backgroundColor: UIColor = .white
    
    
    /**
     客製化選項背景顏色 'default .white'
     */
    public static var optionButtonBackgroundColor: UIColor = UIColor.white
    
    
    /**
     客製化字體
     */
    public static var optionButtonTextFont: UIFont = UIFont.systemFont(ofSize: 16.0)
    
    /**
     客製化Border顏色
     */
    public static var optionButtonBorderColor: UIColor = UIColor.Blue.mainBlue
    
    /**
     OptionButton 客製化 text color
     */
    public static var optionButtonTextColor: UIColor = UIColor.darkText
    
    /**
     OptionButton 客製化 inset, default is UIEdgeInsetsMake(5.0, 7.0, 5.0, 7.0)
     */
    public static var optionButtonContentInset = UIEdgeInsetsMake(5.0, 7.0, 5.0, 7.0)
    
    /**
     Custom title text
     */
    public static var titleText: String = ""
    
    
    /**
     Custom title's font
     */
    public static var titleFont: UIFont = UIFont.systemFont(ofSize: 16.0)
    
    
    /**
     Custom title's default title color '預設值 customTextColor'
     */
    public static var titleTextColor: UIColor = UIColor.darkText
    
    /**
     Custom title's backgroundColor
     */
    public static var titleBackgroundColor: UIColor = UIColor.white
    
    /**
     Custom clean button icon
     */
    public static var cleanButtonIconImage: UIImage {
        return UIImage.init(named: "SwiftySearchResource.bundle/images/trash", in: bundle, compatibleWith: nil) ?? UIImage().withRenderingMode(.alwaysTemplate)
    }        
    
    /**
     Custom clean button tintColor, default 'UIColor.Blue.mainBlue'
     */
    public static var cleanButtonTintColor: UIColor = UIColor.Blue.mainBlue
    
    /**
     Custom clean button default title '預設值 CleanAll'
     */
    public static var cleanButtonTitle: String = "CleanAll".localized
    
    
    /**
     Custom clean button default title color '預設值 customTextColor'
     */
    public static var cleanButtonTitleTextColor: UIColor = UIColor.darkText
    
}

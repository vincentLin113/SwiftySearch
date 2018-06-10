//
//  DynamicSearchCell.swift
//  Job1111
//
//  Created by Vincent Lin on 14/04/2018.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit

@objc protocol SwiftySearchCellDelgate: NSObjectProtocol {
    /**
     當optionButton被點選時呼叫
     - parameter cell                        :                 the cell include those option buttons
     - parameter optionIndex                 :                 選項的順序
     - parameter optionButton                :                 被點選的那個button
     */
    func didSelectedOption(_ cell: SwiftySearchCell,
                           optionIndex: Int,
                           optionButton: UIButton)
    /**
     當cleanButton被點選時呼叫
     - parameter cell                        :                 the cell include those option buttons
     - parameter cleanButton                 :                 被點選的那個清除button
     */
    func didSelectedCleanButton(_ cell: SwiftySearchCell,
                                cleanButton: UIButton)
    /**
     當高度改變時呼叫
     - parameter cell                        :                 the cell include those option buttons
     - parameter height                      :                 目前新高度
     */
    @objc optional func heightDidUpdated(heightFor cell: SwiftySearchCell,
                          height: CGFloat)
    /**
     當Cell高度確定時呼叫
     - parameter cell                        :                 the cell include those option buttons
     - parameter height                      :                 最後的高度
     */
    func updateToFinalCellHeight(heightFor cell: SwiftySearchCell,
                         height: CGFloat)
}

open class SwiftySearchCell: UITableViewCell {
    
    //MARK: - 常數變數

    private var optionButtons: [UIButton] = []
    
    var receiveOptionData: [String] = [] {
        didSet {
            setupOptionView()       // 設定選項畫面
        }
    }
    
    /**
     這個cell的事件代理
     */
    weak var delegate: SwiftySearchCellDelgate?
    
    
    
    //MARK: - UI Declaration
    
    /**
     上面會放置 title, cleanButton
     */
    fileprivate let titleView: UIView = {
       let _titleView = UIView()
        _titleView.isHidden = true
        return _titleView
    }()
    
    /**
     The title label on the titleView, show something like : "SearchRecord", "HotSearch"
     default hidden
     */
    private let titleLabel: UILabel = {
       let _titleLabel = UILabel()
        _titleLabel.isHidden = true
        return _titleLabel
    }()
    
    /**
     The remove all / clean button on the titleView, actions call delegate method to do something
     default hidden
     */
    private let cleanButton: UIButton = {
        let _cleanButton = UIButton()
        _cleanButton.isHidden = true
        return _cleanButton
    }() 

    
    //MARK: - Initial methods
    
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, optionButtonTextArray: [String]) {
        receiveOptionData = optionButtonTextArray
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()     // 基礎顏色設定, 增加子畫面
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()     // 基礎顏色設定, 增加子畫面
    }
    
    //MARK: - Setup Views
    
    /**
     基礎顏色設定, 增加子畫面
     */
    private func configure() {
        selectionStyle = .none
        backgroundColor = SwiftySearchCellCustom.backgroundColor
        contentView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(cleanButton)
    }

    
    override open func layoutSubviews() {
        super.layoutSubviews()
        setupTitleView()        // 設定title, cleanButton
    }
    
    
    //MARK: - Actions
    

    private func setupTitleView() {
        
        titleLabel.text = SwiftySearchCellCustom.titleText
        titleLabel.font = SwiftySearchCellCustom.titleFont
        titleLabel.textColor = SwiftySearchCellCustom.titleTextColor
        
        if !SwiftySearchCellCustom.isHiddenCleanButton {
            cleanButton.setImage(SwiftySearchCellCustom.cleanButtonIconImage, for: UIControlState())
            cleanButton.tintColor = SwiftySearchCellCustom.cleanButtonTintColor
            cleanButton.setTitle(SwiftySearchCellCustom.cleanButtonTitle, for: UIControlState())
            cleanButton.setTitleColor(SwiftySearchCellCustom.cleanButtonTitleTextColor, for: UIControlState())
            cleanButton.backgroundColor = UIColor.white
        }

        let distanceWithBoth: CGFloat = 10.0
        
        let rightTargetAnchor = !SwiftySearchCellCustom.isHiddenCleanButton
        ? cleanButton.leftAnchor
        : titleView.rightAnchor       // 因為若不顯示cleanButton, titleLabel's rightAnchor會找不到
        titleLabel.anchorWithConstansToTop( nil,
            left: titleView.leftAnchor,
            bottom: nil,   // 上下不定義是因為 我會設定中間對齊
            right: rightTargetAnchor,
            topConstant: 0.0,
            leftConstant: 15.0,
            rightConstant: distanceWithBoth,
            bottomConstant: 0.0
        )
        titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        titleLabel.isHidden = false
        
        if !SwiftySearchCellCustom.isHiddenCleanButton {
            cleanButton.anchorWithConstansToTop( nil,
                                                 left: nil,
                                                 bottom: nil,    // 上下不定義是因為 我會設定中間對齊
                right: titleView.rightAnchor,
                topConstant: 0.0,
                leftConstant: 0.0,
                rightConstant: 15.0,
                bottomConstant: 0.0
            )
            cleanButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
            let adjustButtonWidth: CGFloat = cleanButton.intrinsicContentSize.width + 15.0 // 太擠不好看
            cleanButton.widthAnchor.constraint(equalToConstant: adjustButtonWidth).isActive = true
            cleanButton.heightAnchor.constraint(equalTo: cleanButton.widthAnchor, multiplier: 1.0).isActive = true
            cleanButton.isHidden = false
            cleanButton.backgroundColor = .white
            cleanButton.removeTarget(self, action: nil, for: .allEvents)
            cleanButton.addTarget(self, action: #selector(cleanAction(sender:)), for: .touchUpInside)
        } else {
            cleanButton.isHidden = true
            cleanButton.widthAnchor.constraint(equalToConstant: 0.0).isActive = true
        }

        titleView.backgroundColor = SwiftySearchCellCustom.titleBackgroundColor
        titleView.anchorWithConstansToTop( contentView.topAnchor,
                                           left: contentView.leftAnchor,
                                           bottom: nil,
                                           right: contentView.rightAnchor,
                                           topConstant: 0.0,
                                           leftConstant: 0.0,
                                           rightConstant: 0.0,
                                           bottomConstant: 0.0
        )
        
        titleView.heightAnchor.constraint(equalToConstant: SwiftySearchCellCustom.textViewHeight).isActive = true
        titleView.isHidden = false
        
    }
    
    

    private func setupOptionView() {
        if optionButtons.count > 0 {
            return
        }
        var currentX: CGFloat = 15
        var currentY: CGFloat = SwiftySearchCellCustom.textViewHeight + 10.0
        for (index,optionText) in receiveOptionData.enumerated() {
            assert(optionText != "", "optionText不該為空")
            if optionText == "" {
                continue
            }
            let optionButton = generateOptionButton(optionText,
                                                    index: index,
                                                    currentX: currentX,
                                                    currentY: currentY)
            contentView.addSubview(optionButton)
            optionButtons.append(optionButton)
            
            let bottomSpace: CGFloat = 50.0   // 留點底距離 比較美
            if currentX != optionButton.frame.maxX {
                currentX = optionButton.frame.maxX
            }
            if currentY != optionButton.frame.minY {
                currentY = optionButton.frame.minY
                if delegate != nil {
                    delegate?.heightDidUpdated?(heightFor: self,
                                               height: optionButton.frame.maxY + bottomSpace)
                }
            }
            
            if index == receiveOptionData.count - 1 {
                // 最後一個 也就是最後的高度
                if delegate != nil {
                    delegate?.updateToFinalCellHeight(heightFor: self,
                                                      height: optionButton.frame.maxY + bottomSpace)
                }
            }
        }
    }
    
    /**
     產生選項Button
     - parameter optionText     :      選項文字
     - parameter index          :      tag, 用來回傳
     - parameter currentX       :      目前x, 用來計算下一個button's frame
     - parameter currentY       :      目前y, 用來計算下一個button's frame
     - return                   :      UIButton, 這樣才能更新current的值
     */
    private func generateOptionButton(_ optionText: String,
                                      index: Int,
                                      currentX: CGFloat,
                                      currentY: CGFloat) -> UIButton {
        
        let button = UIButton()
        button.setTitle(optionText, for: UIControlState())
        button.setTitleColor(SwiftySearchCellCustom.optionButtonTextColor, for: UIControlState())
        button.backgroundColor = SwiftySearchCellCustom.optionButtonBackgroundColor
        button.titleLabel?.font = SwiftySearchCellCustom.optionButtonTextFont
        button.layer.borderColor = SwiftySearchCellCustom.optionButtonBorderColor.cgColor
        button.layer.borderWidth = 1.0
        button.tag = index
        button.removeTarget(self, action: #selector(optionAction(sender:)), for: .allEvents)
        button.addTarget(self, action: #selector(optionAction(sender:)), for: .touchUpInside)
        button.contentEdgeInsets = SwiftySearchCellCustom.optionButtonContentInset
        let buttonHeight: CGFloat = button.intrinsicContentSize.height + 5.0
        
        var estimateButtonWidth = calculateOptionButtonWidth(optionText)
        
        let allowableWidth = frame.width - 15.0 - 15.0   // 畫面最大的允許寬度
        if estimateButtonWidth > allowableWidth {
            
            if currentX == 15.0 {
                estimateButtonWidth = allowableWidth - 15.0
            } else {
                estimateButtonWidth = allowableWidth
            }
        }
        
        
        var estimateButtonX = currentX
        var estimataButtonY = currentY
        if currentX + estimateButtonWidth > allowableWidth {
            estimateButtonX = 15.0
            let lineSpace: CGFloat = 15.0    // 換行中間的距離
            estimataButtonY += buttonHeight + lineSpace
        } else {
            if estimateButtonX > 15.0 {
                let optionButtonSpace: CGFloat = 10.0     // 兩個optionButton的距離
                estimateButtonX += optionButtonSpace
            }
        }
        
        
        button.frame = CGRect(x: estimateButtonX,
                              y: estimataButtonY,
                              width: estimateButtonWidth,
                              height: buttonHeight)
        
        button.clipsToBounds = true
        button.layer.cornerRadius = buttonHeight / 2.0
        
        return button
    }
    
    
    /**
     計算選項button的寬度
     - parameter optionText:         選項文字
     - returns:                      CGFloat, 寬度
     */
    private func calculateOptionButtonWidth(_ optionText: String) -> CGFloat {
        let buttonInnerInset: CGFloat = 15.0
        return optionText.widthOfString(usingFont: SwiftySearchCellCustom.optionButtonTextFont) + (buttonInnerInset * 2)
    }

    
    /**
     選項按鈕點擊事件
     呼叫delegate, 呼應事件
     */
    @objc private func optionAction(sender: UIButton) {
        if delegate != nil {
            delegate?.didSelectedOption(self, optionIndex: sender.tag, optionButton: sender)
        }
    }
    
    @objc private func cleanAction(sender: UIButton) {
        if delegate != nil {
            delegate?.didSelectedCleanButton(self, cleanButton: sender)
        }
    }
    
}







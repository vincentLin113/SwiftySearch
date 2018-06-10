//
//  StyleHighlightCell.swift
//  Job1111
//
//  Created by Vincent Lin on 15/04/2018.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit


class StyleHighlightCell: UITableViewCell {
    
    /**
     設定在點擊時亮起colorBarView
     */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        colorBarView.isHidden = !isSelected

    }

    /**
     設定在highlight時亮起colorBarView
     若開啟 customSetting.style.isShowSelectionBackgroundView
     則會亮起背景view
     */
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        colorBarView.isHidden = !highlighted
        if StyleHighlightCellCustom.isShowSelectionBackgroundView {
            if highlighted {
                backgroundColor = StyleHighlightCellCustom.highlightColor.withAlphaComponent(StyleHighlightCellCustom.highlightViewAlpha)
            } else {
                backgroundColor = .white
            }
        }
    }
    
    /**
     客製化物件
     */
    public var customSetting = StyleHighlightCellCustom()

    private let colorBarView: UIView = {
       let _colorBarView = UIView()
        _colorBarView.isHidden = true
        return _colorBarView
    }()
    
    
    //MARK: - Initial methods
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    /**
     Setting subViews
     */
    private func configure() {
        contentView.addSubview(colorBarView)
        selectionStyle = .none
    }
    
    /**
     Add Constraints
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        setupColorBarView()
    }
    
    /**
     Add constraints for colorBarView,
     set color by customSetting.style.highlightColor
     */
    private func setupColorBarView() {
        colorBarView.anchorWithConstansToTop(
            contentView.topAnchor,
            left: contentView.leftAnchor,
            bottom: contentView.bottomAnchor,
            right: nil,
            topConstant: StyleHighlightCellCustom.barTopSpace,
            leftConstant: StyleHighlightCellCustom.barLeftSpace,
            rightConstant: 0.0,
            bottomConstant: StyleHighlightCellCustom.barBottomSpace
        )
        colorBarView.widthAnchor.constraint(equalToConstant: StyleHighlightCellCustom.barWidth).isActive = true
        colorBarView.backgroundColor = StyleHighlightCellCustom.highlightColor
    }
    

}

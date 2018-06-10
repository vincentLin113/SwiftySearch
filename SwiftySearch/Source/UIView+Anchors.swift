//
//  UIView + Anchors.swift
//  JSONPratice
//
//  Created by Vincent Lin on 2018/6/9.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /**
     Easily to use anchor constraint, and set translatesAutoresizingMaskIntoConstraints = false
     - parameter top                                 :                  topAnchor target parent's anchor
     - parameter left                                :                  leftAnchor target parent's anchor
     - parameter bottom                              :                  bottomAnchor target parent's anchor
     - parameter right                               :                  rightAnchor target parent's anchor
     - parameter topConstant                         :                  distance between parent's topAnchor
     - parameter leftConstant                        :                  distance between parent's leftAnchor
     - parameter bottomConstant                      :                  distance between parent's bottomAnchor
     - parameter rightConstant                       :                  distance between parent's rightAnchor
     */
    func anchorWithConstansToTop(_ top:NSLayoutYAxisAnchor? = nil,
                                 left:NSLayoutXAxisAnchor? = nil,
                                 bottom: NSLayoutYAxisAnchor? = nil,
                                 right: NSLayoutXAxisAnchor? = nil,
                                 topConstant:CGFloat = 0,
                                 leftConstant:CGFloat = 0,
                                 rightConstant:CGFloat = 0,
                                 bottomConstant:CGFloat = 0) {
        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
    }
    
    /**
     Easily to use anchor constraint, and set translatesAutoresizingMaskIntoConstraints = false
     - parameter top                                 :                  topAnchor target parent's anchor
     - parameter left                                :                  leftAnchor target parent's anchor
     - parameter bottom                              :                  bottomAnchor target parent's anchor
     - parameter right                               :                  rightAnchor target parent's anchor
     - parameter topConstant                         :                  distance between parent's topAnchor
     - parameter leftConstant                        :                  distance between parent's leftAnchor
     - parameter bottomConstant                      :                  distance between parent's bottomAnchor
     - parameter rightConstant                       :                  distance between parent's rightAnchor
     - return                                        :                  Array of NSLayoutConstraint, is optional
     */
    func anchor(_ top:NSLayoutYAxisAnchor? = nil,
                left:NSLayoutXAxisAnchor? = nil,
                bottom:NSLayoutYAxisAnchor? = nil,
                right:NSLayoutXAxisAnchor? = nil,
                topConstant:CGFloat = 0,
                leftConstant:CGFloat = 0,
                bottomConstant:CGFloat = 0,
                rightConstant:CGFloat = 0) -> [NSLayoutConstraint]? {
        translatesAutoresizingMaskIntoConstraints = false
        let anchors = [NSLayoutConstraint]()
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -rightConstant).isActive = true
        }
        anchors.forEach({$0.isActive = true})
        return anchors
    }
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours, locations: nil)
    }
    
    func applyGradient(_ colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func anchorWithSameConstantToView(_ top:NSLayoutYAxisAnchor?,
                                      left:NSLayoutXAxisAnchor?,
                                      bottom: NSLayoutYAxisAnchor?,
                                      right: NSLayoutXAxisAnchor?,
                                      sameValue: CGFloat) {
        self.anchorWithConstansToTop(top, left: left, bottom: bottom, right: right, topConstant: sameValue, leftConstant: sameValue, rightConstant: sameValue, bottomConstant: sameValue)
    }
}

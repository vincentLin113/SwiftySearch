//
//  SwiftySearch + UserDefaults.swift
//  JSONPratice
//
//  Created by Vincent Lin on 2018/6/9.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation

public protocol UserDefaultSettable {
    var uniqueKey: String { get }
}


extension UserDefaultSettable where Self: RawRepresentable, Self.RawValue == String {
    
    public func store(_ value: Any?) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    
    public var storedValue: Any? {
        return UserDefaults.standard.value(forKey: uniqueKey)
    }
    
    public func clean() {
        UserDefaults.standard.set(nil, forKey: uniqueKey)
    }
}

extension String: UserDefaultSettable {
    public var uniqueKey: String {
        return self
    }
}

extension UserDefaults {
    enum Key: String, UserDefaultSettable {
        
        var uniqueKey: String {
            return self.rawValue
        }
        
        case searchHistory = "SWIFTYSEARCHHISTORY"
    }
}





























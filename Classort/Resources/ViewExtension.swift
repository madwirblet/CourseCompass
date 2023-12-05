//
//  ViewExtension.swift
//  Classort
//
//  Created by Devin Wylde on 11/29/23.
//

import UIKit

extension UIView {
    public var width: CGFloat {
        get {
            return frame.size.width
        } set {
            frame.size.width = newValue
        }
    }
    
    public var height: CGFloat {
        get {
            return frame.size.height
        } set {
            frame.size.height = newValue
        }
    }
    
    public var top: CGFloat {
        get {
            return frame.origin.y
        } set {
            frame.origin.y = newValue
        }
    }
    
    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    
    public var left: CGFloat {
        get {
            return frame.origin.x
        } set {
            frame.origin.x = newValue
        }
    }
    
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
}

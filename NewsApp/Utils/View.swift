//
//  View.swift
//  NewsApp
//
//  Created by Jérémie Bonsant on 2020-08-28.
//

import UIKit

class View: UIView {
    
    var postInitNotReached = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        internalPostInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalPostInit()
    }
    
    override open class var requiresConstraintBasedLayout: Bool {
        get {
            // We let subclasses override this in cases where Auto Layout is not wanted
            return true
        }
    }
    
    internal func internalPostInit() {
        #if DEBUG
            postInitNotReached = true
        #endif
        
        postInit()
        
        #if DEBUG
            if (postInitNotReached) {
                assert(!postInitNotReached, "super.PostInit() not called for \(self.description)")
            }
        #endif
    }
    
    func postInit() {
        self.translatesAutoresizingMaskIntoConstraints = !type(of: self).requiresConstraintBasedLayout
        postInitNotReached = false
    }
}

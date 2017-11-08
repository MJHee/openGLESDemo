//
//  AGLKContext.swift
//  openGLESDemo
//
//  Created by HeMengjie on 2017/10/27.
//  Copyright © 2017年 hmj. All rights reserved.
//

import GLKit

class AGLKContext: EAGLContext {
    var clearColor : GLKVector4 {
        set {
            self.clearColor = newValue
            glClearColor(newValue.r, newValue.g, newValue.b, newValue.a)
        }
        get {
            return self.clearColor
        }
    }
    
    func clear(mask: GLbitfield) {
        glClear(mask)
    }
    
    func disable(capability: GLenum) {
        glDisable(capability)
    }
    
    func enable(capability: GLenum) {
        glEnable(capability)
    }
    
    func setBlendSourceFuncation(sfactor: GLenum, dfactor: GLenum) {
        glBlendFunc(sfactor, dfactor)
    }
}

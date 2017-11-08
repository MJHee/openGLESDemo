//
//  ViewController2.swift
//  openGLESDemo
//
//  Created by HeMengjie on 2017/10/27.
//  Copyright © 2017年 hmj. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES


struct SceneVertex2 {
    var positionCoords : GLKVector3
}

var vec2 = [
    SceneVertex2(positionCoords: GLKVector3Make(0.5,0.5,0.5)),
    SceneVertex2(positionCoords: GLKVector3Make(-0.5,-0.5,0.5)),
    SceneVertex2(positionCoords: GLKVector3Make(0.5,-0.5,-0.5))
]

class ViewController2: GLKViewController {
    var vertextBuffer = AGLKVertexAttribArrayBuffer()
    var vertextBufferId = GLuint()
    var baseEffect = GLKBaseEffect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! GLKView
        //EAGLContent是苹果在ios平台下实现的opengles渲染层，用于渲染结果在目标surface上的更新。
        view.context = AGLKContext(api: .openGLES3)!
        AGLKContext.setCurrent(view.context)
        self.vertextBuffer.initWithAttribStride(stride: GLsizei(MemoryLayout.size(ofValue: vec2[0])), numberOfVertices: GLsizei(vec2.count), dataPtr: vec2, usage: GLenum(GL_STATIC_DRAW))
    }
    
    //GLKViewDelegate
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        baseEffect.prepareToDraw()
        getCurrentContext().clear(mask: GLenum(GL_COLOR_BUFFER_BIT))
        
        self.vertextBuffer.prepareToDrawWithAttrib(vertexAttrib: AGLKVertexAttrib.AGLKVertexAttribPosition.rawValue, numberOfCoordinates: 3, attribOffset: 0, shouldEnable: true)
        
        self.vertextBuffer.drawArrayWithMode(mode: GLenum(GL_TRIANGLE_FAN), startVertexIndex: 0, numberOfVertices: GLsizei(vec2.count))
    }
    
    func getCurrentContext() -> AGLKContext {
        let view = self.view as! GLKView
        return view.context as! AGLKContext
    }

}

//
//  ViewController3.swift
//  openGLESDemo
//
//  Created by HeMengjie on 2017/10/27.
//  Copyright © 2017年 hmj. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES



struct SceneVertexExtension {
    var positionCoords : GLKVector3
    var textureCoords: GLKVector2
}

var vec3Extension = [
    SceneVertexExtension(positionCoords: GLKVector3Make(-1.5, -1.5, 0.0),
                textureCoords:GLKVector2Make(0.0, 0.0)),
    SceneVertexExtension(positionCoords: GLKVector3Make(1.5, -1.5, 0.0),
                textureCoords:GLKVector2Make(1.0, 0.0)),
    SceneVertexExtension(positionCoords: GLKVector3Make(1.5, 1.5, 0.0),
                textureCoords:GLKVector2Make(1.0, 1.0)),
    SceneVertexExtension(positionCoords: GLKVector3Make(-1.5, 1.5, 0.0),
                textureCoords:GLKVector2Make(0.0, 1.0))
]

class ViewController3: GLKViewController {
    var vertextBuffer = AGLKVertexAttribArrayBuffer()
    var vertextBufferId = GLuint()
    var baseEffect = GLKBaseEffect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! GLKView
        //EAGLContent是苹果在ios平台下实现的opengles渲染层，用于渲染结果在目标surface上的更新。
        view.context = AGLKContext(api: .openGLES3)!
        AGLKContext.setCurrent(view.context)
        self.vertextBuffer.initWithAttribStride(stride: GLsizei(MemoryLayout.size(ofValue: vec3Extension[0])), numberOfVertices: GLsizei(vec3Extension.count), dataPtr: vec3Extension, usage: GLenum(GL_STATIC_DRAW))
        
        //开启深度测试，就是让离你近的物体可以遮挡离你远的物体。
        glEnable(GLenum(GL_DEPTH_TEST))
        //设置surface的清除颜色，也就是渲染到屏幕上的背景色
        glClearColor(0.1, 0.2, 0.3, 1)
        
        //设置纹理
        let imageRef = UIImage.init(named: "1")?.cgImage
        var textureInfo: GLKTextureInfo!
        do {
            textureInfo = try GLKTextureLoader.texture(with: imageRef!, options: nil)
        }catch {
            
        }

        self.baseEffect.texture2d0.name = textureInfo.name
        self.baseEffect.texture2d0.target = GLKTextureTarget(rawValue: textureInfo.target)!
    }
    
    //GLKViewDelegate
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        baseEffect.prepareToDraw()
        getCurrentContext().clear(mask: GLenum(GL_COLOR_BUFFER_BIT))
        
        self.vertextBuffer.prepareToDrawWithAttrib(vertexAttrib: AGLKVertexAttrib.AGLKVertexAttribPosition.rawValue, numberOfCoordinates: 3, attribOffset: 0, shouldEnable: true)
        
        //绑定纹理数据
        self.vertextBuffer.prepareToDrawWithAttrib(vertexAttrib: AGLKVertexAttrib.AGLKVertexAttribTexCoord0.rawValue, numberOfCoordinates: 2, attribOffset: MemoryLayout<GLfloat>.size * 4, shouldEnable: true)
        
        self.vertextBuffer.drawArrayWithMode(mode: GLenum(GL_TRIANGLE_FAN), startVertexIndex: 0, numberOfVertices: GLsizei(vec3Extension.count))
    }
    
    func getCurrentContext() -> AGLKContext {
        let view = self.view as! GLKView
        return view.context as! AGLKContext
    }
}

//
//  ViewController.swift
//  openGLESDemo
//
//  Created by HeMengjie on 2017/10/26.
//  Copyright © 2017年 hmj. All rights reserved.
//

import UIKit
import GLKit

extension GLKEffectPropertyTexture {
    func aglkSetParameter(parameterID: GLenum, value: GLint) {
        glBindTexture(self.target.rawValue, self.name)
        //设定纹理参数
        glTexParameteri(self.target.rawValue, parameterID, value)
    }
}

struct SceneVertex4 {
    var positionCoors : GLKVector3
    var textureCoors : GLKVector2
}

var vec4 = [
    SceneVertexExtension(positionCoords: GLKVector3Make(-0.5, -0.5, 0.0),
                         textureCoords:GLKVector2Make(0.0, 0.0)),
    SceneVertexExtension(positionCoords: GLKVector3Make(0.5, -0.5, 0.0),
                         textureCoords:GLKVector2Make(1.0, 0.0)),
    SceneVertexExtension(positionCoords: GLKVector3Make(0.5, 0.5, 0.0),
                         textureCoords:GLKVector2Make(1.0, 1.0)),
    SceneVertexExtension(positionCoords: GLKVector3Make(-0.5, 0.5, 0.0),
                         textureCoords:GLKVector2Make(0.0, 1.0))
]

var DefaultVertices = [
    SceneVertexExtension(positionCoords: GLKVector3Make(-0.5, -0.5, 0.0),
                         textureCoords:GLKVector2Make(0.0, 0.0)),
    SceneVertexExtension(positionCoords: GLKVector3Make(0.5, -0.5, 0.0),
                         textureCoords:GLKVector2Make(1.0, 0.0)),
    SceneVertexExtension(positionCoords: GLKVector3Make(0.5, 0.5, 0.0),
                         textureCoords:GLKVector2Make(1.0, 1.0)),
    SceneVertexExtension(positionCoords: GLKVector3Make(-0.5, 0.5, 0.0),
                         textureCoords:GLKVector2Make(0.0, 1.0))
]

var movementVectors: [GLKVector3] = [
    GLKVector3Make(-0.01, -0.01, 0.0),
    GLKVector3Make(0.01, -0.01, 0.0),
    GLKVector3Make(0.01, 0.01, 0.0),
    GLKVector3Make(-0.01, 0.01, 0.0)
]

class ViewController: GLKViewController {
    var vertextureBuffer = AGLKVertexAttribArrayBuffer()
    var vertextBufferId = GLuint()
    var baseEffect = GLKBaseEffect()
    
    var shouldUseLinearFilter = true
    var shouldAnimate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredFramesPerSecond = 60
        
        let view = self.view as! GLKView
        view.context = AGLKContext(api: .openGLES3)!
        AGLKContext.setCurrent(view.context)
        
        //开启深度测试，就是让离你近的物体可以遮挡离你远的物体。
        glEnable(GLenum(GL_DEPTH_TEST))
        //设置surface的清除颜色，也就是渲染到屏幕上的背景色
        glClearColor(0.1, 0.2, 0.3, 1)
        self.vertextureBuffer.initWithAttribStride(stride: GLsizei(MemoryLayout.size(ofValue: vec4[0])), numberOfVertices: GLsizei(vec4.count), dataPtr: vec4, usage: GLenum(GL_STATIC_DRAW))
        
        let imageRef = UIImage.init(named: "1")?.cgImage
        var textureInfo: GLKTextureInfo!
        do {
            textureInfo = try GLKTextureLoader.texture(with: imageRef!, options: nil)
        } catch {
            
        }
        self.baseEffect.texture2d0.name = textureInfo.name
        self.baseEffect.texture2d0.target = GLKTextureTarget(rawValue: textureInfo.target)!
        
        //添加滤镜按钮
        let takeShouldUseLinearFilterFrom = UISwitch(frame: CGRect(x: 30, y: UIScreen.main.bounds.size.height - 100, width: 50, height: 30))
        takeShouldUseLinearFilterFrom.addTarget(self, action: #selector(self.takeShouldUseLinearFilterFrom(sender:)), for: .valueChanged)
        takeShouldUseLinearFilterFrom.setOn(true, animated: false)
        self.view.addSubview(takeShouldUseLinearFilterFrom)
        let takeShouldUseLinearFilterFromLab = UILabel(frame: CGRect(x: 5, y: UIScreen.main.bounds.size.height - 60, width: 100, height: 20))
        takeShouldUseLinearFilterFromLab.text = "添加滤镜"
        takeShouldUseLinearFilterFromLab.textColor = UIColor.white
        takeShouldUseLinearFilterFromLab.textAlignment = .center
        self.view.addSubview(takeShouldUseLinearFilterFromLab)
        //添加动画按钮
        let takeShouldAnimateFrom = UISwitch(frame: CGRect(x: UIScreen.main.bounds.size.width - 110, y: UIScreen.main.bounds.size.height - 100, width: 50, height: 30))
        
        takeShouldAnimateFrom.addTarget(self, action: #selector(self.takeShouldAnimateFrom(sender:)), for: .valueChanged)
        takeShouldAnimateFrom.setOn(true, animated: false)
        self.view.addSubview(takeShouldAnimateFrom)
        let takeShouldAnimateFromLab = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width - 135, y: UIScreen.main.bounds.size.height - 60, width: 100, height: 20))
        takeShouldAnimateFromLab.text = "添加动画"
        takeShouldAnimateFromLab.textColor = UIColor.white
        takeShouldAnimateFromLab.textAlignment = .center
        self.view.addSubview(takeShouldAnimateFromLab)
    }
    
    //GLKViewDelegate
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        baseEffect.prepareToDraw()
        getCurrentContext().clear(mask: GLenum(GL_COLOR_BUFFER_BIT))
        
        self.vertextureBuffer.prepareToDrawWithAttrib(vertexAttrib: AGLKVertexAttrib.AGLKVertexAttribPosition.rawValue, numberOfCoordinates: 3, attribOffset: 0, shouldEnable: true)
        
        //绑定纹理数据
        self.vertextureBuffer.prepareToDrawWithAttrib(vertexAttrib: AGLKVertexAttrib.AGLKVertexAttribTexCoord0.rawValue, numberOfCoordinates: 2, attribOffset: MemoryLayout<GLfloat>.size * 4, shouldEnable: true)
        
        self.vertextureBuffer.drawArrayWithMode(mode: GLenum(GL_TRIANGLE_FAN), startVertexIndex: 0, numberOfVertices: GLsizei(vec4.count))
    }
    
    func getCurrentContext() -> AGLKContext {
        let view = self.view as! GLKView
        return view.context as! AGLKContext
    }
    
    func update() {
        //添加滤镜
        self.updateTextureParameters()
        //添加动画
        self.updateAnimatedVertexPositions()
        //重新加载缓存数据
        self.vertextureBuffer.reinitWithAttribStride(stride: GLsizei(MemoryLayout.size(ofValue: vec4[0])), numberOfVertices: GLsizei(vec4.count), dataPtr: vec4)
    }
    
    //添加动画
    func updateAnimatedVertexPositions() {
        if shouldAnimate == true {
            for index in 0...3 {
                vec4[index].positionCoords = GLKVector3Make(vec4[index].positionCoords.x + movementVectors[index][0], vec4[index].positionCoords.y, vec4[index].positionCoords.z)
                if vec4[index].positionCoords.x >= 1.0 || vec4[index].positionCoords.x <= -1.0 {
                    movementVectors[index] = GLKVector3Make(-movementVectors[index][0], movementVectors[index][1], movementVectors[index][2])
                }
                if vec4[index].positionCoords.y >= 1.0 || vec4[index].positionCoords.y <= -1.0 {
                    movementVectors[index] = GLKVector3Make(movementVectors[index][0], -movementVectors[index][1], movementVectors[index][2])
                }
                if vec4[index].positionCoords.z >= 1.0 || vec4[index].positionCoords.z <= -1.0 {
                    movementVectors[index] = GLKVector3Make(movementVectors[index][0], movementVectors[index][1], -movementVectors[index][2])
                }
            }
        }else {
            vec4 = DefaultVertices
        }
    }
    //添加滤镜
    func updateTextureParameters() {
        self.baseEffect.texture2d0.aglkSetParameter(parameterID: GLenum(GL_TEXTURE_MAG_FILTER), value: self.shouldUseLinearFilter ? GL_LINEAR : GL_NEAREST)
    }
    //是否添加动画
    @objc func takeShouldAnimateFrom(sender: UISwitch) {
        self.shouldAnimate = sender.isOn
    }
    //是否添加滤镜
    @objc func takeShouldUseLinearFilterFrom(sender: UISwitch) {
        self.shouldUseLinearFilter = sender.isOn
    }
}





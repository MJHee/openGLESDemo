//
//  ViewController1.swift
//  openGLESDemo
//
//  Created by HeMengjie on 2017/10/27.
//  Copyright © 2017年 hmj. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES


struct SceneVertex1 {
    var positionCoords : GLKVector3
}

var vec1 = [
    SceneVertex1(positionCoords: GLKVector3Make(0.5,0.5,0.5)),
    SceneVertex1(positionCoords: GLKVector3Make(-0.5,-0.5,0.5)),
    SceneVertex1(positionCoords: GLKVector3Make(0.5,-0.5,-0.5))
]

class ViewController1: GLKViewController {
    var vertextBufferId: GLuint = GLuint()
    var baseEffect = GLKBaseEffect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! GLKView
        //EAGLContent是苹果在ios平台下实现的opengles渲染层，用于渲染结果在目标surface上的更新。
        view.context = EAGLContext(api: .openGLES3)!
        EAGLContext.setCurrent(view.context)
        
        //开启深度测试，就是让离你近的物体可以遮挡离你远的物体。
        glEnable(GLenum(GL_DEPTH_TEST))
        //设置surface的清除颜色，也就是渲染到屏幕上的背景色
        glClearColor(0.1, 0.2, 0.3, 1)
        
        //使用恒定不变的颜色
        baseEffect.useConstantColor = GLboolean(UInt8(GL_TRUE))
        baseEffect.constantColor = GLKVector4Make(1, 0, 1, 1)
        
        /**
         &0：生成缓存标识符的数量
         &1：生成标识符的内存位置
         */
        glGenBuffers(1, &vertextBufferId)
        
        //绑定缓存
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertextBufferId)
        
        //缓存数据
        glBufferData(GLenum(GL_ARRAY_BUFFER), vec1.size(), vec1, GLenum(GL_STATIC_DRAW))
    }
    
    //GLKViewDelegate
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        baseEffect.prepareToDraw()
        glClear(GLenum(GL_COLOR_BUFFER_BIT))
        glEnableVertexAttribArray(0)
        glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(UInt8(GL_FALSE)), GLsizei(MemoryLayout<SceneVertex1>.size), nil)
        glDrawArrays(
            GLenum(GL_TRIANGLE_FAN),//根据实际来设置样式
            //GL_TRIANGLE_FAN 是一个铺满的三角形
            //GL_LINE_LOOP 就成了一个空心的三角形
            //GL_LINES 则是一条线，其它的效果可以自己分别体验。
            0,//从bufffers中的第一个vertice开始
            GLsizei(vec1.count))
    }
}

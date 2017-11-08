//
//  AGLKVertexAttribArrayBuffer.swift
//  openGLESDemo
//
//  Created by HeMengjie on 2017/10/27.
//  Copyright © 2017年 hmj. All rights reserved.
//

import UIKit


enum AGLKVertexAttrib: GLuint {
    case AGLKVertexAttribPosition = 0
    case AGLKVertexAttribNormal = 1
    case AGLKVertexAttribColor = 2
    case AGLKVertexAttribTexCoord0 = 3
    case AGLKVertexAttribTexCoord1 = 4
}

//封装顶点数组缓存
class AGLKVertexAttribArrayBuffer: NSObject {
    //步幅，表示每一个顶点需要多少字节
    var stride = GLsizei()
    //缓存大小
    var bufferSizeBytes = GLsizeiptr()
    //缓存唯一标识
    var bufferId = GLuint()
    
    
    /**
     创建顶点数组缓存
     stride:           步幅
     numberOfVertices: Vertices大小
     bytes:            Vertices内存地址
     usage:            是否缓存在GPU
     
     */
    func initWithAttribStride(stride: GLsizei, numberOfVertices: GLsizei, dataPtr: UnsafeRawPointer, usage: GLenum) {
        self.stride = stride
        bufferSizeBytes = Int(stride) * Int(numberOfVertices)
        
        glGenBuffers(1, &bufferId)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.bufferId)
        glBufferData(GLenum(GL_ARRAY_BUFFER), bufferSizeBytes, dataPtr, usage)
    }
    
    
    //重新加载缓存数据
    func reinitWithAttribStride(stride: GLsizei, numberOfVertices:GLsizei, dataPtr:  UnsafeRawPointer) {
        self.stride = stride
        bufferSizeBytes = Int(stride) * Int(numberOfVertices)
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.bufferId)
        glBufferData(GLenum(GL_ARRAY_BUFFER), bufferSizeBytes, dataPtr, GLenum(GL_DYNAMIC_DRAW))
    }
    
    /**
     Description
     index:               VertexAttrib
     numberOfCoordinates: 坐标轴数
     attribOffset:        从开始的每个顶点偏移
     shouldEnable:        启用（Enable）或者禁用（Disable）
     */
    func prepareToDrawWithAttrib(vertexAttrib: GLuint, numberOfCoordinates: GLint, attribOffset: GLsizeiptr, shouldEnable: Bool) {
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.bufferId)
        
        if shouldEnable == true {
            glEnableVertexAttribArray(vertexAttrib)
        }
        
        glVertexAttribPointer(vertexAttrib, numberOfCoordinates, GLenum(GL_FLOAT), GLboolean(UInt8(GL_FALSE)), self.stride, nil)
        
    }
    
    //绘制图片
    func drawArrayWithMode(mode:GLenum, startVertexIndex: GLint, numberOfVertices: GLsizei) {
        glDrawArrays(mode, startVertexIndex, numberOfVertices);
    }
    
    //删除缓存
    deinit {
        if 0 != bufferId {
            glDeleteBuffers(1, &bufferId)
            bufferId = 0
        }
    }
}

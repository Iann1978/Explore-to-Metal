//
//  Renderer.swift
//  HelloMetal-Swift
//
//  Created by iann on 2019/7/22.
//  Copyright © 2019 luciglobal. All rights reserved.
//

import Foundation
import Metal
import MetalKit

class Renderer : NSObject, MTKViewDelegate {
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    let vertexBuffer: MTLBuffer
    
    // This is the initializer for the Renderer class.
    // We will need access to the mtkView later, so we add it as a parameter here.
    init?(mtkView: MTKView) {
        device = mtkView.device!
        commandQueue = device.makeCommandQueue()!
        
        do {
            pipelineState = try Renderer.buildRenderPipelineWith(device: device, metalKitView: mtkView)
        }
        catch{
            print("Unable to compile render pipeline state: \(error)")
            return nil
        }
        
        let vertices = [Vertex(color: [1,0,0,1], pos: [-1,-1]),
                        Vertex(color: [1,1,0,1], pos: [0,1]),
                        Vertex(color: [1,1,1,1], pos: [1,-1])]
        
        
        
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])!
        
        
        
    }
    
    // Create our custom rendering pipeline, which loads shaders using 'device', and outputs to the format of 'metalKitView'
    class func buildRenderPipelineWith(device :MTLDevice, metalKitView: MTKView) throws -> MTLRenderPipelineState {
        // Create a new pipeline descriptor
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        let library = device.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    // mtkView will automatically call this function
    // whennever it wants new content to be rendered.
    func draw(in view: MTKView) {
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1,0,0,1)
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder.endEncoding()
        

        
        commandBuffer.present(view.currentDrawable!)
        
        commandBuffer.commit()
        
    }
    
    // mtkView will automatically call this funcion
    // whenever the size of view changeds (such as resizing the window).
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}

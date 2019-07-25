//
//  Renderer.m
//  HelloMetal-OC
//
//  Created by iann on 2019/7/23.
//  Copyright © 2019 luciglobal. All rights reserved.
//

#import "Renderer.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@implementation Renderer {
    id<MTLBuffer> vertexBuffer;
    id <MTLRenderPipelineState> pipelineState;
}
- (instancetype) init:(MTKView *) mtkView
{
    device = mtkView.device;
    queue = device.newCommandQueue;

    
    static const float vertexArrayData[] = {
        0.5,-0.25,0,1,
        -0.5,-0.25,0,1,
        0,0.5,0,1,
    };
    vertexBuffer = [device newBufferWithBytes:vertexArrayData length:sizeof(vertexArrayData) options:0];
    
    
    
    MTLRenderPipelineDescriptor *des = [MTLRenderPipelineDescriptor new];
    id<MTLLibrary> library = [device newDefaultLibrary];
    des.vertexFunction = [library newFunctionWithName:@"myVertexShader"];
    des.fragmentFunction = [library newFunctionWithName:@"myFragmentShader"];
    des.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
    NSError *error;
    pipelineState = [device newRenderPipelineStateWithDescriptor:des error:&error];
    
    return self;
}

- (void)drawInMTKView:(nonnull MTKView *)view
{
    id<MTLCommandBuffer> buffer = queue.commandBuffer;
    MTLRenderPassDescriptor *passDesc = view.currentRenderPassDescriptor;
    passDesc.colorAttachments[0].clearColor = MTLClearColorMake(1, 0, 0, 1);
    
    
    id <MTLRenderCommandEncoder> encorder = [buffer renderCommandEncoderWithDescriptor: passDesc];
    [encorder setCullMode:MTLCullModeNone];
    [encorder setFrontFacingWinding:MTLWindingCounterClockwise];
    [encorder setRenderPipelineState: pipelineState];
    [encorder setVertexBuffer:vertexBuffer offset:0 atIndex:0];
    [encorder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
    [encorder endEncoding];
    [buffer presentDrawable:view.currentDrawable];
    [buffer commit];
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
    id<MTLCommandBuffer> commandBuffer = [queue commandBuffer];
    
}




@end

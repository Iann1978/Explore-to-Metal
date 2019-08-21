//
//  Renderer.m
//  HelloMetal-OC
//
//  Created by iann on 2019/7/23.
//  Copyright © 2019 luciglobal. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "Renderer.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import "ShaderTypes.h"

@implementation Renderer {
    id<MTLBuffer> vertexBuffer;
    id <MTLRenderPipelineState> pipelineState;
    id<MTLTexture> texture;
}
- (instancetype) init:(MTKView *) mtkView
{
    device = mtkView.device;
    queue = device.newCommandQueue;

    
    static const MyVertex vertexArrayData[] = {
        {{0.5,-0.25,0,1},{0.75,0.25}},
        {{-0.5,-0.25,0,1},{0.25,0.25}},
        {{0,0.5,0,1},{0,0.75}},
    };
    vertexBuffer = [device newBufferWithBytes:vertexArrayData length:sizeof(vertexArrayData) options:0];
    
    
    
    MTLRenderPipelineDescriptor *des = [MTLRenderPipelineDescriptor new];
    id<MTLLibrary> library = [device newDefaultLibrary];
    des.vertexFunction = [library newFunctionWithName:@"myVertexShader"];
    des.fragmentFunction = [library newFunctionWithName:@"myFragmentShader"];
    des.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
    NSError *error;
    pipelineState = [device newRenderPipelineStateWithDescriptor:des error:&error];
    
    [self loadTexture];
    return self;
}

- (void) loadTexture
{
    
    NSError *error;
//    NSImage *image = [NSImage imageNamed:@"abc"];
//    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
//    textureDescriptor.pixelFormat = MTLPixelFormatRGBA8Unorm;
//    textureDescriptor.width = image.size.width;
//    textureDescriptor.height = image.size.height;
//    texture = [device newTextureWithDescriptor:textureDescriptor];
//    //self.texture = [self.mtkView.device newTextureWithDescriptor:textureDescriptor]; // 创建纹理
    
    MTKTextureLoader* textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    
    NSDictionary *textureLoaderOptions =
    @{
      MTKTextureLoaderOptionTextureUsage       : @(MTLTextureUsageShaderRead),
      MTKTextureLoaderOptionTextureStorageMode : @(MTLStorageModePrivate)
      };
    
    texture = [textureLoader newTextureWithName:@"abc"
                                      scaleFactor:1.0
                                           bundle:nil
                                          options:textureLoaderOptions
                                            error:&error];
    int a = 0;
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
    [encorder setFragmentTexture:texture atIndex:0];
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

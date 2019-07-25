//
//  Renderer.h
//  HelloMetal-OC
//
//  Created by iann on 2019/7/23.
//  Copyright © 2019 luciglobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Renderer : NSObject<MTKViewDelegate>
{
@public
    id<MTLDevice> device;
    id<MTLCommandQueue> queue;

}
- (instancetype) init:(MTKView *) mtkView;
- (void)drawInMTKView:(nonnull MTKView *)view;
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size;
@end

NS_ASSUME_NONNULL_END

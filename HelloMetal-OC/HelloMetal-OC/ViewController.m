//
//  ViewController.m
//  HelloMetal-OC
//
//  Created by iann on 2019/7/23.
//  Copyright © 2019 luciglobal. All rights reserved.
//

#import "ViewController.h"
#import "Renderer.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (![self.view isKindOfClass:[MTKView class]])
    {
        printf("View attached to ViewController is not an MTKView!");
        return;
    }
    
    mtkView = (MTKView *)self.view;
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    NSString *name = [device name];
    NSString *name1 = [mtkView.device name];
    mtkView.device = device;
   
    
    Renderer *renderer = [[Renderer alloc] init: mtkView];
    [renderer mtkView:mtkView drawableSizeWillChange:mtkView.bounds.size];
    mtkView.delegate = renderer;
    [renderer drawInMTKView:mtkView];
}


//- (void)setRepresentedObject:(id)representedObject {
//    [super setRepresentedObject:representedObject];
//
//    // Update the view, if already loaded.
//}


@end

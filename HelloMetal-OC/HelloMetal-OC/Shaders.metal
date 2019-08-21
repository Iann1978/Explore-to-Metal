//
//  Shaders.metal
//  HelloMetal-OC
//
//  Created by iann on 2019/7/25.
//  Copyright © 2019 luciglobal. All rights reserved.
//

#include <metal_stdlib>
#import "ShaderTypes.h"
using namespace metal;

typedef struct
{
    float4 position [[position]];;
    float2 uv;
} VertexIn;

typedef struct
{
    float4 position [[position]];
    float2 uv;
} VertexOut;

vertex VertexOut myVertexShader(const device VertexIn* vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]])
{
    VertexOut verOut;
    verOut.position = vertexArray[vid].position;
    verOut.uv = vertexArray[vid].uv;
    return verOut;
}

fragment float4 myFragmentShader( VertexOut vertexIn [[stage_in]],
                                 texture2d<half> colorMap     [[ texture(0) ]])
{
    constexpr sampler colorSampler(mip_filter::linear,
                                   mag_filter::linear,
                                   min_filter::linear);
    
    half4 colorSample   = colorMap.sample(colorSampler, vertexIn.uv.xy);
    
    return float4(colorSample);
}

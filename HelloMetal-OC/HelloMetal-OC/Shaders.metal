//
//  Shaders.metal
//  HelloMetal-OC
//
//  Created by iann on 2019/7/25.
//  Copyright © 2019 luciglobal. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

typedef struct
{
    float4 position;
} VertexIn;

typedef struct
{
    float4 position [[position]];
} VertexOut;

vertex VertexOut myVertexShader(const device VertexIn* vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]])
{
    VertexOut verOut;
    verOut.position = vertexArray[vid].position;
    return verOut;
}

fragment float4 myFragmentShader( VertexOut vertexIn [[stage_in]])
{
    return float4(0,1,0,1);
}

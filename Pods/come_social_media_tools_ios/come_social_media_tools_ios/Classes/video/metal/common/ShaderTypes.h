//
//  ShaderTypes.h
//  YunNeutronDemo
//
//  Created by fuhao on 2022/7/26.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>



//缓存数据索引
typedef enum BufferIndices {
    kBufferIndexMeshPositions_v1    = 0,
} BufferIndices;


//顶点属性索引
typedef enum VertexAttributes {
    kVertexAttributePosition_v1  = 0,
    kVertexAttributeTexcoord_v1  = 1,
    kVertexAttributeNormal_v1    = 2
} VertexAttributes;


//纹理索引
typedef enum TextureIndices {
    kTextureIndexColor_v1    = 0,
    kTextureIndexY_v1        = 1,
    kTextureIndexCbCr_v1     = 2
} TextureIndices;


#endif /* ShaderTypes_h */

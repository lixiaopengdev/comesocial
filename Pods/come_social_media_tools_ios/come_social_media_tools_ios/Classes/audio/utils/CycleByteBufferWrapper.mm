//
//  CycleByteBufferWrapper.m
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/3/9.
//

#import <Foundation/Foundation.h>
#import "CycleByteBufferWrapper.h"
#include "CycleByteBuffer.h"


@interface CycleByteBufferWrapper ()
@property (nonatomic, assign) CycleByteBuffer* buffer;
@end

@implementation CycleByteBufferWrapper

-(id) init {
    self = [super init];
    if(self){
        _buffer = new CycleByteBuffer();
    }
    return self;
}

-(void) setBufferSize:(int) bufferSize {
    if(_buffer){
        _buffer->setBufferSize(bufferSize);
    }
}
-(int) readBuffer:(unsigned char *)data ReadBytes:(int) readBytes {
    if(_buffer){
        return _buffer->readBuffer(data, readBytes);
    }
    return 0;
}

//-(int) readBufferIfCloud:(unsigned char *)data ReadBytes:(int) readBytes {
//    if(_buffer){
//        return _buffer->readBufferIfCloud(data, readBytes);
//    }
//    return 0;
//}
-(void) writeBuffer:(unsigned char *)data ReadBytes:(int) writeBytes {
    if(_buffer){
        return _buffer->writeBuffer(data, writeBytes);
    }
}

-(int) getAvaliableSize {
    if(_buffer){
        return _buffer->getAvaliableSize();
    }
    return 0;
}

@end

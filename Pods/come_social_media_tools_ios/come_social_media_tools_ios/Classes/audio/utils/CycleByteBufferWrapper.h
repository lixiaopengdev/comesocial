//
//  CycleByteBufferWrapper.h
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/3/9.
//

#import <Foundation/Foundation.h>




@interface CycleByteBufferWrapper : NSObject

-(void) setBufferSize:(int) bufferSize;
-(int) readBuffer:(unsigned char *)data ReadBytes:(int) readBytes;
//-(int) readBufferIfCloud:(unsigned char *)data ReadBytes:(int) readBytes;

-(void) writeBuffer:(unsigned char *)data ReadBytes:(int) writeBytes;
-(int) getAvaliableSize;
@end

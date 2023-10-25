//
//  CycleByteBuffer.hpp
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/3/9.
//

#ifndef CycleByteBuffer_hpp
#define CycleByteBuffer_hpp

#include <stdio.h>
#include <pthread.h>

class CycleByteBuffer {

    
private:
    int kBufferLengthBytes ;
    int readIndex ;
    int writeIndex ;
    int availableBytes ;
    char* byteBuffer ;
    pthread_mutex_t mutex ;
    
    void releaseBuffer();
    
public:
    CycleByteBuffer();
    ~CycleByteBuffer(void);

    void setBufferSize(int bufferSize);
    int readBuffer(void* data,int readBytes);
    int readBufferIfCloud(void* data,int readBytes);
    void writeBuffer(void* pcmData,int bytesLength);
    int getAvaliableSize();
};





#endif /* CycleByteBuffer_hpp */

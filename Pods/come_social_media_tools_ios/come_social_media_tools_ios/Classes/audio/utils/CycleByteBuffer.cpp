//
//  CycleByteBuffer.cpp
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/3/9.
//

#include "CycleByteBuffer.h"
#include <string.h>
#include <stdlib.h>

CycleByteBuffer::CycleByteBuffer() {
    kBufferLengthBytes = 0;
    readIndex = 0;
    writeIndex = 0;
    availableBytes = 0;
    byteBuffer = NULL;
    pthread_mutex_init(&mutex, NULL);
}

CycleByteBuffer::~CycleByteBuffer(void){ releaseBuffer(); }

void CycleByteBuffer::releaseBuffer() {
    if(byteBuffer != NULL){
        free(byteBuffer);
        byteBuffer = NULL;
    }
    
    kBufferLengthBytes = 0;
    readIndex = 0;
    writeIndex = 0;
    availableBytes = 0;
}



void CycleByteBuffer::setBufferSize(int bufferSize){
    releaseBuffer();
    kBufferLengthBytes = bufferSize;
    byteBuffer = (char*)malloc(bufferSize);
}

int CycleByteBuffer::readBufferIfCloud(void* data,int readBytes) {
    if (NULL == data || readBytes < 1 ) {
//                NSLog(@"注意：无数据可读");
        return 0;
    }
    
    int cloudReadBytes = availableBytes < readBytes ? availableBytes : readBytes;
    return readBuffer(data, cloudReadBytes);
}

int CycleByteBuffer::readBuffer(void* data,int readBytes) {
    
    
    if (NULL == data || readBytes < 1 || availableBytes < readBytes) {
//                NSLog(@"注意：无数据可读");
        return 0;
    }
    
    pthread_mutex_lock(&mutex);

    if (readIndex + readBytes > kBufferLengthBytes) {
        int left = kBufferLengthBytes - readIndex;
        memcpy(data, byteBuffer + readIndex, left);
        memcpy((char*)data + left, byteBuffer, readBytes - left);
        readIndex = readBytes - left;
    }
    else {
        memcpy(data, byteBuffer + readIndex, readBytes);
        readIndex += readBytes;
    }
    
    availableBytes -= readBytes;
    pthread_mutex_unlock(&mutex);
    
    
    return readBytes;
}

void CycleByteBuffer::writeBuffer(void* pcmData,int bytesLength) {
    pthread_mutex_lock(&mutex);
    
    if (availableBytes + bytesLength > kBufferLengthBytes) {
//        NSLog(@"注意：造成一次数组写满");
        readIndex = 0;
        writeIndex = 0;
        availableBytes = 0;
    }
    
    if (writeIndex + bytesLength > kBufferLengthBytes) {
        int left = kBufferLengthBytes - writeIndex;
        memcpy(byteBuffer + writeIndex, pcmData, left);
        memcpy(byteBuffer, (char *)pcmData + left, bytesLength - left);
        writeIndex = bytesLength - left;
    }
    else {
        memcpy(byteBuffer + writeIndex, pcmData, bytesLength);
        writeIndex += bytesLength;
    }
    
    availableBytes += bytesLength;
    pthread_mutex_unlock(&mutex);
}

int CycleByteBuffer::getAvaliableSize() {
    return availableBytes;
}





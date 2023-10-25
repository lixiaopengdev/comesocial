var global = this
;(function() {
    
// 数据类型处理
global.$color = function(color) {
    return oc_color(color);
};
    
global.$rgb = function(red,green,blue) {
    return oc_color_rgba(red,green,blue);
};
    
global.$rgba = function(red,green,blue,alpha) {
    return oc_color_rgba(red,green,blue,alpha);
};
    
global.$font = function(v1,v2) {
    return oc_font(v1,v2);
};

global.$componentType= {
    baseVideoComponent : "baseVideoComponent",
    audioCard: "audio_card",
    videoBlurCard: "video_blur_card",
    videoChangerCard: "video_changer_card",
    partyCard: "party_card",
    silencingCard: "silencingCard",
    quickPhotoCard: "quickPhotoCard",
    textWindowCard: "textWindowCard",
    autoPhotoCard: "autoPhotoCard",
    front_backVideoCard: "front_backVideoCard",
    pictureWindowCard: "pictureWindowCard",
    mileageDisplayCard: "mileageDisplayCard",
    timeDewCard: "timeDewCard",
    stationedTextingCard: "stationedTextingCard"
}

// 卡片设置数据类型
global.$optionType = {
    switch_type: "switch",
    list_type: "list",
}

global.$cameraDirection = {
    camera_direction_front: "front",
    camera_direction_back: "back",
    camera_direction_bf: "back&front",
}

// 卡片设置选项
global.$option_list = function(name, type, options) {
    this.name = name;
    this.type = type;
    this.options = options;
};

// 用户自定义卡片设置
global.$exportParameterSettings = function(toogleSwitchs, optionLists) {
    
};
    
var settingMessage = {};
// 用户设置完成后调用此方法，将设置回填至js内
global.$setParameterSettings = function(jsonData) {
    var message = JSON.parse(jsonData);
    settingMessage = message;
    oc_log(settingMessage);
}

// 获取用户设置
global.$getParameterSettings = function() {
    return settingMessage;
}

// 打印 log
global.$console = {
    log : function(data) {
        oc_log(data);
    }
};

// 更新某个卡片UI信息
global.$widget = {
    render : function(data) {
        cs_renderWidget(data);
    },
    update: function(data) {
        cs_updateWidget(data);
    },
    destroy: function(data) {
        cs_destroyWidget(data);
    },
};
    
// alert 弹窗
global.$alert = {
    showMessage: function(data) {
        cs_showMessage(data);
    }
}

// 当前房间设置功能
global.$room = {
    // 修改当前房间信息 data包含背景音乐和背景图片
    updateRoom: function(data) {
        cs_updateRoom(data);
    }
}

// 对用户相关的设置，进场约束等
global.$enter = {
    // 对参加者进行的约束
    participatingMembers: function(data) {
        cs_participatingMembers(data);
    },
    // 进场手势约束
    enterGesture: function(data) {
        cs_enterGesture(data);
    }
}
    
global.$user = {
    // 禁言用户
    silence: function(data) {
        cs_silence(data);
    },
    getCurrentUserInfo: function(data) {
      return cs_getCurrentUserInfo(data);
    }
}
    
// 照片创作
global.$photo = {
    // 上传照片
    uploadPhoto: function(data) {
        cs_uploadPhoto(data)
    }
}
    
global.$timer = {
    setInterval: function(fun,arg) {
        setInterval_js(fun, arg)
    },
    stopInterval: function(data) {
        stopInterval(data);
    }
}
    
// 麦克风相关功能调用
global.$microphone = {
    // 开始音频流 data中包含施加对象
    startAudio: function(data) {
        cs_startAudioCapture(data);
    },
    // 停止音频流 data中包含施加对象
    stopAudio: function(data) {
        cs_stopAudioCapture(data);
    },
    // 音频添加滤镜 data 中包含滤镜施加对象和滤镜ID
    applyAudioEffectFilter: function(data) {
        cs_applyAudioEffectFilter(data);
    },
    // 获取当前施加对象麦克风状态
    getCurrentMicrophoneStatus: function(data) {
       return cs_getCurrentMicrophoneStatus(data);
    }
}

// 摄像头相关功能调用
global.$camera = {
    // 开始视频流 data中包含施加对象
    startVideo: function(data) {
        cs_startVideoCapture(data);
    },
    // 停止视频流 data中包含施加对象
    stopVideo: function(data) {
        cs_stopVideoCapture(data);
    },
    
    // 前后摄像头切换 data中包含施加对象 和指定前后摄像头
    switchCamera: function(data) {
        cs_switchCameraSource(data);
    },
    // 拍照 --》可能需要直接替换施加者视图
    takePhoto: function(data) {
        cs_takePhoto(data);
    },
    // 视频添加滤镜 data 中包含滤镜施加对象和滤镜ID
    applyVideoEffectFilter: function(data) {
        cs_applyVideoEffectFilter(data);
    },
    // 视频添加面具 data中包含面具施加对象和面具ID
    applyVideoEffectAvatar: function(data) {
        cs_applyVideoAvatar(data);
    },
    
    // 获取当前控制视图的摄像头状态，是否打卡，前摄像头还是后摄像头打开,需要配合使用
    getCurrentCameraStatus: function(data) {
      return cs_getCurrentCameraStatus(data);
    }
};

// 广播， data为要同步给房间内其他用户的消息
global.$broadcast = {
    js_broadcast: function(data) {
        cs_broadcast(data);
    }
}

// 网络请求
global.$http = {
    get : function(data) {
        data.method = 'GET';
        oc_request(data);
    },
    post : function(data) {
        data.method = 'POST';
        oc_request(data);
    },
};

})()

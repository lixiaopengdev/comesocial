
const ButtonType = Object.freeze({
    switch_button: "switch_button",
    action_button: "action_button"
});

const TransitionEffectType = Object.freeze({
    transitionEffect_1: "transitionEffect_1",
    transitionEffect_2: "transitionEffect_2"
});

function Condition(content, transitionEffect) {
    this.content = content; // 文字or字典
    this.transitionEffect = transitionEffect;
}

//JS Button标签类
function Button(buttonType, widgetId, action, click_effect, conditions) {
    this.buttonType = buttonType;
    this.widgetId = widgetId;
    this.action = action;
    this.click_effect = click_effect;
    this.conditions = conditions;
}

// label 类
function Label(text, textColor){
    this.text = text;
    this.textColor = textColor;
}

const WidgetType = Object.freeze({
    WidgetType_Video: "VideoWidget",
    WidgetType_Message: "MessageWidget"
})


const CommonActionType = Object.freeze({
    commonActionType_js: "commonActionType_js",
});

function CommonAction(content) {
    this.commonAction = content;
}

function TextComponent(content) {
    this.textComponent = content;
}

function ButtonComponent(content) {
    this.buttonComponent = content;
}

function Widget(content) {
    this.widget = content;
}

//JS 基础视频卡
function VideoWidget(cameraButton, microphone, viewOptions){
    this.WidgetType = WidgetType.WidgetType_Video;
    this.cameraButton = cameraButton;
    this.microphone = microphone;
    this.viewOptions = viewOptions;
}

//JS 文字窗卡测试
function MessageWidget(button1, button2){
    this.WidgetType = WidgetType.WidgetType_Message;
    this.button1 = button1;
    this.button2 = button2;
}

//JS 文字窗卡
function TextWindowCard(textCount, editPermissions){
    this.WidgetType = WidgetType.WidgetType_Message;
    this.textCount = textCount;
    this.editPermissions = editPermissions;
}

//JS 照片聊天卡
function QuickPhotoCard(cameraButton, photo){
    this.cameraButton = cameraButton;
    this.photo = photo;
}



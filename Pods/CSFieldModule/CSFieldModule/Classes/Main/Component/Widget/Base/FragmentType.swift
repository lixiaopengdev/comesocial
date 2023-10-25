//
//  FragmentType.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/15.
//

enum FragmentType: String {
    case textComponent = "TextComponent"
    case buttonComponent = "ButtonComponent"
    case baseVideoComponent = "BaseVideoComponent"
    case textInputComponent = "TextInputComponent"
    case imageComponent = "ImageComponent"
    case stationedTextingComponent = "StationedTextingComponent"
    
    case userLabelComponent = "MileageDisplayComponent"
    case timeDewComponent = "TimeDewComponent"

    case livePhotoComponent = "LivePhotoComponent"
    case mapComponent = "MapComponent"
    case chatComponent = "ChatComponent"

    
    
    var widgetFragmentType: WidgetFragment.Type {
        switch self {
        case .textComponent:
            return TextFragment.self
        case .buttonComponent:
            return ButtonFragment.self
        case .baseVideoComponent:
            return FaceTimeFragment.self
        case .textInputComponent:
            return TextInputFragment.self
        case .imageComponent:
            return ImageFragment.self
        case .stationedTextingComponent:
            return StationaryChatFragment.self
        case .userLabelComponent:
            return UserLabelFragment.self
        case .timeDewComponent:
            return TimeDewFragment.self
        case .livePhotoComponent:
            return LivePhotoFragment.self
        case .mapComponent:
            return MapFragment.self
        case .chatComponent:
            return ChatFragment.self
        }
    }
    
    var widgetFragmentViewType: WidgetFragmentView.Type {
        switch self {
        case .textComponent:
            return TextFragmentView.self
        case .buttonComponent:
            return ButtonFragmentView.self
        case .baseVideoComponent:
            return FaceTimeFragmentView.self
        case .textInputComponent:
            return TextInputFragmentView.self
        case .imageComponent:
            return ImageFragmentView.self
        case .stationedTextingComponent:
            return StationaryChatFragmentView.self
        case .userLabelComponent:
            return UserLabelFragmentView.self
        case .timeDewComponent:
            return TimeDewFragmentView.self
        case .livePhotoComponent:
            return LivePhotoFragmentView.self
        case .mapComponent:
            return MapFragmentView.self
        case .chatComponent:
            return ChatFragmentView.self
        }
    }
    
    
}

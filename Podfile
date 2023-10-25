
platform :ios, '13.0'

source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
source 'git@github.com:NeoWorldTeam/ComeSocialSpecs.git'


#inhibit_all_warnings!

# 是否使用本地库
def pod_source(pod_name, version = "", sub = "", use_local_pods = false)
  new_pod_name = pod_name
  if sub != ""
    new_pod_name = "#{pod_name}/#{sub}"
  end
  if use_local_pods
    pod "#{new_pod_name}", :path => "../#{pod_name}"
  else
    if version == ""
      pod "#{new_pod_name}", :git => "git@github.com:NeoWorldTeam/#{pod_name}.git"
    else
      pod "#{new_pod_name}", :git => "git@github.com:NeoWorldTeam/#{pod_name}.git", :tag => "#{version}"
    end
  end
end

def base_pod
  if ENV['useFeatureCN'] == '1'
    #useFeatureCN=1 pod install
    pod 'WhisperDiarization', '~> 0.4.8'
  else
    pod 'WhisperDiarization', '~> 0.3.9'
  end
  
  pod 'YPImagePicker', :git => 'git@github.com:yudongdongcoder/YPImagePicker.git', :tag => '5.5.6'
  pod 'IGListKit', :git => 'git@github.com:yudongdongcoder/IGListKit.git', :tag => '4.9.0'
  pod 'IGListDiffKit', :git => 'git@github.com:yudongdongcoder/IGListKit.git', :tag => '4.9.0'
  pod 'IGListSwiftKit', :git => 'git@github.com:yudongdongcoder/IGListKit.git', :tag => '4.9.0'
  pod 'AuthManagerKit', :git => 'git@github.com:NeoWorldTeam/AuthManagerKit.git', :tag => '0.0.10'
  
  pod 'ComeSocialRTCService', '~> 0.3.1'
  pod 'come_social_media_tools_ios', '~> 0.3.3'
  pod 'JSEngineKit', :git => 'git@github.com:NeoWorldTeam/JSEngineKit.git', :branch =>'develop'
  pod 'CSSpyExpert', :git => 'git@github.com:NeoWorldTeam/CSSpyExpert.git', :tag => '0.2.21'
  pod 'CSTimeDewMoreViewController', :git => 'git@github.com:NeoWorldTeam/CSTimeDewMoreViewController.git', :tag => '0.1.0'
  pod 'CSTimeDewPosting', :git => 'git@github.com:NeoWorldTeam/CSTimeDewPosting.git', :tag => '0.1.6'

  
  
  pod_source('CSUtilities', '0.0.15')

  pod_source('CSNetwork', '0.0.4')
  pod_source('CSImageKit', '0.0.2')
  pod_source('CSWebsocket', '0.0.2')
  pod_source('CSLogger', '0.0.1')
  pod_source('CSFileKit', '0.0.1')
  pod_source('CSBaseView', '0.0.10')
  pod_source('CSRouter', '0.0.6')
  pod_source('CSAccountManager', '0.0.4')
  pod_source('CSCommon', '0.0.12')
  pod_source('CSListView', '0.0.12')
  pod_source('CSPermission', '0.0.6')
  pod_source('CSMediator', '0.0.4')
  pod_source('CSTracker', '0.0.5')
  pod_source('CSADTracker', '0.0.2')

end


def module_pod
  

  pod_source('CSLiveModule', '0.4.21')
  pod_source('ComeSocialRootModule', '0.0.15')
  if ENV['product'] == '1'
    pod_source('ComeSocialRootModule', '0.0.15', "Product")
  end
  pod_source('CSFriendsModule', '0.0.15')
  pod_source('CSMeModule', '0.0.29')
  pod_source('CSFieldModule', '0.0.20')
  
end

# debug pod

def debug_pod
  
  pod 'FBRetainCycleDetector', :git => 'git@github.com:facebook/FBRetainCycleDetector.git', :configurations => ['Debug']
  pod 'DoraemonKit/Core', :configurations => ['Debug'] #必选
  #  pod 'DoraemonKit/WithGPS', '~> 3.0.7', :configurations => ['Debug'] #可选
  #  pod 'DoraemonKit/WithLoad', '~> 3.0.7', :configurations => ['Debug'] #可选
  #  pod 'DoraemonKit/WithLogger', '~> 3.0.7', :configurations => ['Debug'] #可选
  #  pod 'DoraemonKit/WithDatabase', '~> 3.0.7', :configurations => ['Debug'] #可选
  pod 'DoraemonKit/WithMLeaksFinder', :configurations => ['Debug'] #可选
  
end


target 'ComeSocial' do
  use_frameworks!
  use_modular_headers!
  
  
  debug_pod
  
  module_pod
  base_pod
  
  
#  target 'ComeSocialTests' do
#    inherit! :search_paths
#  end
#
#  target 'ComeSocialUITests' do
#    inherit! :search_paths
#  end
  
end

target 'Ruleless' do
  use_frameworks!
  use_modular_headers!
  
  
  debug_pod
  
  module_pod
  base_pod

  
end

post_install do |installer|
  
  
  installer.pods_project.targets.each do |target|
    if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
      target.build_configurations.each do |config|
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
  
end



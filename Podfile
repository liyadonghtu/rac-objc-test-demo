platform :ios, '8.0'
def commonPods #通用pods集
    pod 'AFNetworking', '~> 3.0'
    pod 'Masonry', '~> 1.1.0'
    pod 'ReactiveObjC', '~> 3.1.1'

end

def appOnlyPods #app专用pods集
  

end


def aMapPods #地图专用pods集
#    pod 'AMapNavi'  #已包含3D地图，无需单独引入3D地图
#    pod 'AMapSearch'  #搜索功能
#    pod 'AMapLocation' #定位功能
end


target :TestIos do
    commonPods
    appOnlyPods
    aMapPods
end


import Foundation
import AMapLocationKit
import CoreLocation

public struct AddressComponent {
    public var coordinate: CLLocationCoordinate2D? //坐标
    public var country: String? //国家
    public var porvince: String? //省份
    public var city: String? //市
    public var cityCode: String? //城市编码
    public var district: String? //区
    public var adcode: String? //区域编码
    public var township: String? //乡镇街道
    public var towncode: String? //乡镇街道编码
    public var neighborhood: String? // 社区
    public var building: String? //建筑
    
    public init() { }
    
}

public protocol LocationProvider {
    //地理位置回调
    typealias UpdateLocationCallback = (_ coor: CLLocationCoordinate2D) -> Void
    // 地理位置解析
    typealias RegeoSuccessCallback = (AddressComponent) -> Void
    //
    typealias GeoSuccessCallback = (AddressComponent) -> Void
    // 获取当前地理位置信息
    var coordinate: CLLocationCoordinate2D? { get }
    // 地理位置信息
    var addressComponent: AddressComponent? { get }
    // 更新地理位置信息
    func updateLocation(callback: UpdateLocationCallback?)
    // 停止更新位置信息
    func stopLocation()
    // 根据坐标反编码出地理位置
    func regeoCode(_ coor: CLLocationCoordinate2D, callback: RegeoSuccessCallback?)
    // 根据中文地理位置，解析出具体的经纬度
    func geocode(_ addr: String, callback: GeoSuccessCallback?)
    
}

public class LocationManager {
    
    private static var locationPorvider: LocationProvider?
    
    public static func registerLocationProvider(_ provider: LocationProvider?) {
        guard let provider = provider else {
            fatalError("请在主工程中注册provider")
        }
        locationPorvider = provider
    }
    //检测是否支持定位
    public static var isSupportLocation: Bool {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .denied || authStatus == .notDetermined || authStatus == .restricted {
            return false
        }
        return true
    }
    // 获取用户地理位置
    public static var coordinate: CLLocationCoordinate2D? {
        return locationPorvider?.coordinate
    }
    // 获取用户地理位置
    public static var addressComponent: AddressComponent? {
        return locationPorvider?.addressComponent
    }
    
    // 更新用户地理位置
    public static func updateLocation(callback: LocationProvider.UpdateLocationCallback?) {
        locationPorvider?.updateLocation(callback: callback)
    }
    
    // 停止更新位置
    public static func stopLocation() {
        locationPorvider?.stopLocation()
    }
    
    // 根据经纬度，进行反编码
    public static func regeocode(_ coor: CLLocationCoordinate2D, callback: @escaping LocationProvider.RegeoSuccessCallback) {
        locationPorvider?.regeoCode(coor, callback: callback)
    }
    
    
}

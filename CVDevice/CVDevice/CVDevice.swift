//
//  CVDevice.swift
//  LYMusic
//
//  Created by caven on 2018/11/17.
//  Copyright © 2018 caven-twy. All rights reserved.
//


/// 在本类中可以获取设备的一些信息，包括：设备型号，设备名称，IP地址，WIFI名字，WIFI的MAC地址
/// 

import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork
import KeychainAccess

public struct CVDevice {
    
    /// 官方设备型号-名字：https://www.theiphonewiki.com/wiki/Models
    /// 获取设备的型号, eg: iPhone 11,2
    static func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    /// 获取设备名字, eg: iPhone XS Max
    static func getDeviceName() -> String {
        
        guard let path = Bundle.main.path(forResource: "iPhoneModels", ofType: "plist") else {
            return "Unkown Device"
        }
        
        let modelInfo = NSDictionary.init(contentsOfFile: path)!
        if let model = modelInfo.object(forKey: getDeviceModel()) {
            return model as! String
        }
        return "Unkown Device"
    }
    
    /// 获取IP地址, eg: 192.168.31.57
    static func getIPAddresses() -> String {
        
        var address: String?
        
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        
        guard getifaddrs(&ifaddr) == 0 else { return "0.0.0.0"}
        guard let firstAddr = ifaddr else { return "0.0.0.0" }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr,
                                socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address ?? "0.0.0.0"
    }
    
    /// 获取WIFI 名字
    static func getWifiName() -> String {
        return self.getWIFIInfo().0
    }
    
    /// 获取WIFI MAC 地址
    static func getWifiMacAddress() -> String {
        return self.getWIFIInfo().1
    }
    
    /// 设备的唯一标示UUID（这里的UUID是不改变的，除非重置手机）
    static func getUUID() -> String {
        
        struct PriviteKey {
            static let server = "com.caven.project.keychain"
            static let UUID = "com.caven.project.UUID"
        }
        
        var uuid = try! Keychain.init(service: PriviteKey.server).get(PriviteKey.UUID)
        if uuid == nil {
            uuid = NSUUID().uuidString
            try! Keychain.init(service: PriviteKey.server).set(uuid!, key: PriviteKey.UUID)
        }
        
        return uuid!
    }
}

extension CVDevice {
    /// 系统版本号
    static let sysVersion = UIDevice.current.systemVersion
    /// 系统的名称， eg:"iOS", "tvOS", "watchOS", "macOS"
    static let sysName = UIDevice.current.systemName
    
}

// MARK: - Pravite Method
private extension CVDevice {
    
    typealias IPName = String
    typealias IPMacAddress = String
    static func getWIFIInfo() -> (IPName, IPMacAddress) {
        
        let interfaces: NSArray = CNCopySupportedInterfaces()!
        var ssid: String?
        var mac: String?
        
        for sub in interfaces {
            
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(sub as! CFString)) {
                ssid = dict["SSID"] as? String
                mac = dict["BSSID"] as? String
            }
        }
        return (ssid!, mac!)
    }
    
    
}

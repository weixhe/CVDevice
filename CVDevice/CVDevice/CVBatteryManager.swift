//
//  CVBatteryManager.swift
//  LYMusic
//
//  Created by caven on 2018/11/17.
//  Copyright © 2018 caven-twy. All rights reserved.
//

/// 系统电池管理
import Foundation
import UIKit

public protocol CVBantterManagerDelegate: class {
    
    /// 电池电量发生改变
    func batteryLavelDidUpdated(_ levelPercent: UInt)
    
    /// 电池状态发生变化（已充满，正在充电，未插电）
    func batteryStatusDidUpdated(_ status: String)
}

public class CVBantterManager {
 
    // 单例
    static let share = CVBantterManager()
    
    weak var delegate: CVBantterManagerDelegate?
    
    private(set) var capacity: UInt?    // 电池容量
    private(set) var voltage: UInt? // 电压
    
    private(set) var levelPercent: UInt?    // 电量百分比
    private(set) var status: String?    // 状态
    
}

// MARK: - Public Mathod
extension CVBantterManager {
    
    /// 开启监听电池变化
    func startBatterMonitorint() {
        if isEnabledMonitoring == false {
            NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelUpdated(note:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(batteryLavelStatusUpdate(note:)), name: UIDevice.batteryStateDidChangeNotification, object: nil)

            // 刚开始的时候，手动调用一次状态变化
            if UIDevice.current.batteryState == UIDevice.BatteryState.unknown {
                batteryLavelStatusUpdate(note: nil)
            }
            
            UIDevice.current.isBatteryMonitoringEnabled = true
        }
    }
    
    /// 停止监听电池变化
    func stopBatterMonitorint() {
        if isEnabledMonitoring == true {
            NotificationCenter.default.removeObserver(self)
            UIDevice.current.isBatteryMonitoringEnabled = false
        }
    }
}

// MARK: - Private Method
private extension CVBantterManager {
    
    /// 监听电池电量变化
    @objc func batteryLevelUpdated(note: Notification?) {
        
        levelPercent = UInt(UIDevice.current.batteryLevel) * 100
        self.delegate?.batteryLavelDidUpdated(levelPercent ?? 0)
    }
    
    // 电池状态变化
    @objc func batteryLavelStatusUpdate(note: Notification?) {
        
        
        switch UIDevice.current.batteryState {
        case .charging:     // 正在充电
            if levelPercent ==  100 {
                status = "Fully charged"
            } else {
                status = "Charging"
            }
        case .full:     // 已充满
            status = "Fully charged"
        case .unplugged:        // 没有连接电源线
            status = "Unplugged"
        case .unknown:
            status = "Unknown"
        default:
            break
        }

        self.delegate?.batteryStatusDidUpdated(status!)
    }    
}

// MARK: - Set Get
private extension CVBantterManager {
    // 能否开启监听
    private var isEnabledMonitoring: Bool {
        return UIDevice.current.isBatteryMonitoringEnabled
    }

}

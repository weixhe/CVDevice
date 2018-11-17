//
//  ViewController.swift
//  CVDevice
//
//  Created by caven on 2018/11/17.
//  Copyright © 2018 caven-twy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let text = """
                    设备型号：\(CVDevice.getDeviceModel())
                    设备名称：\(CVDevice.getDeviceName())
                    IP地址：\(CVDevice.getIPAddresses())
                    WIFI名：\(CVDevice.getWifiName())
                    MAC地址：\(CVDevice.getWifiMacAddress())
                    系统版本号：\(CVDevice.sysVersion)
                    系统名称：\(CVDevice.sysName)
                    唯一标识：\(CVDevice.getUUID())
                   """
        
        let label = UILabel(frame: CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 500))
        view.addSubview(label)
        label.numberOfLines = 0
        
        label.text = text
        
        
        CVBantterManager.share.startBatterMonitorint()

    }


    deinit {
        CVBantterManager.share.stopBatterMonitorint()
    }
}



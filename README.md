# CVDevice

## 支持
   iOS系统：8.0以上，swift：4.2以上

## 使用  Pod
   pod 'CVDevice', '~> 1.0.0'
   
## 用法
1. 获取device属性
```
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
```
2. 获取电池相关内容
这里必须开启监听。。。

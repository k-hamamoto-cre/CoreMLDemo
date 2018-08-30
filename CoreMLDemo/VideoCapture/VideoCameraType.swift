//
//  VideoCameraType.swift
//  CoreMLDemo
//
//  Created by kuniaki hamamoto on 2018/07/22.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import AVFoundation

enum VideoCameraType : Int {
    case back
    case front
    
    func captureDevice() -> AVCaptureDevice {
        switch self {
        case .front:
            let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [], mediaType: .video, position: .front).devices
            print("devices:\(devices)")
            for device in devices where device.position == .front {
                return device
            }
        default:
            break
        }
        return AVCaptureDevice.default(for: .video)!
    }
}

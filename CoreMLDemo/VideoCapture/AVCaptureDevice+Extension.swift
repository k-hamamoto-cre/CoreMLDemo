//
//  AVCaptureDevice+Extension.swift
//  CoreMLDemo
//
//  Created by kuniaki hamamoto on 2018/07/27.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import AVFoundation

extension AVCaptureDevice {
    
    private func availableFormatsFor(preferredFps: Float64) -> [AVCaptureDevice.Format]
    {
        var availableFormats: [AVCaptureDevice.Format] = []
        for format in formats
        {
            let ranges = format.videoSupportedFrameRateRanges
            for range in ranges where range.minFrameRate <= preferredFps && preferredFps <= range.maxFrameRate
            {
                // 指定されたfpsをフレームレートの範囲に含むものは追加
                availableFormats.append(format)
            }
        }
        return availableFormats
    }
    
    // 指定されたフォーマット配列から、幅の最も大きいフォーマット1件を返却する
    private func formatWithHighestResolution(_ availableFormats: [AVCaptureDevice.Format]) -> AVCaptureDevice.Format?
    {
        var maxWidth: Int32 = 0
        var selectedFormat: AVCaptureDevice.Format?
        for format in availableFormats {
            let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            let width = dimensions.width
            if width >= maxWidth {
                maxWidth = width
                selectedFormat = format
            }
        }
        return selectedFormat
    }
    
    // 指定されたフォーマット配列とサイズから収まるサイズがあればそれを返却する
    private func formatFor(preferredSize: CGSize, availableFormats: [AVCaptureDevice.Format]) -> AVCaptureDevice.Format?
    {
        for format in availableFormats {
            let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            
            if dimensions.width >= Int32(preferredSize.width) && dimensions.height >= Int32(preferredSize.height)
            {
                return format
            }
        }
        return nil
    }
    
    func updateFormatWithPreferredVideoSpec(preferredSpec: VideoSpec)
    {
        let availableFormats: [AVCaptureDevice.Format]
        if let preferredFps = preferredSpec.fps {
            availableFormats = availableFormatsFor(preferredFps: Float64(preferredFps))
        } else {
            availableFormats = formats
        }
        
        var format: AVCaptureDevice.Format?
        if let preferredSize = preferredSpec.size {
            format = formatFor(preferredSize: preferredSize, availableFormats: availableFormats)
        } else {
            format = formatWithHighestResolution(availableFormats)
        }
        
        guard let selectedFormat = format else {return}
        print("selected format: \(selectedFormat)")
        do {
            try lockForConfiguration()
        } catch {
            fatalError("")
        }
        activeFormat = selectedFormat
        
        if let preferredFps = preferredSpec.fps {
            activeVideoMinFrameDuration = CMTimeMake(1, preferredFps)
            activeVideoMaxFrameDuration = CMTimeMake(1, preferredFps)
            unlockForConfiguration()
        }
    }
}

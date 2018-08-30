//
//  CoreMLUtility.swift
//  CoreMLDemo
//
//  Created by kuniaki hamamoto on 2018/08/23.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation
import CoreML
import Vision

class CoreMLUtility {
    static func getModel() -> VNCoreMLModel {
        
        /*******************************************************
         ** "ModelFileName"の部分をmlmodelファイルのファイル名で置き換える **
         *******************************************************/
        guard let model = try? VNCoreMLModel(for: ModelFileName().model) else {
            abort()
        }
        return model
    }
}

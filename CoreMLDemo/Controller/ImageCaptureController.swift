//
//  ImageCaptureController.swift
//  CoreMLDemo
//
//  Created by kuniaki hamamoto on 2018/07/22.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

class ImageCaptureController: UIViewController, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var predictLabel: UILabel!
    
    private var mlModel : VNCoreMLModel!
    
    private var videoCapture: VideoCapture!

    override func viewDidLoad() {
        super.viewDidLoad()
        // ステータスバー非表示
        self.setNeedsStatusBarAppearanceUpdate()
        
        // 学習データの読み込み
        mlModel = CoreMLUtility.getModel()
        
        let spec = VideoSpec(fps: 1, size: CGSize(width: 1280, height: 720))
        videoCapture = VideoCapture(cameraType: .back,
                                    preferredSpec: spec,
                                    previewContainer: previewView.layer)
        videoCapture.imageBufferHandler = {[unowned self] (imageBuffer, timestamp, outputBuffer) in
            let ciImage = CIImage(cvPixelBuffer: imageBuffer)
            // 画像予測実行
            self.predict2(inputImage: ciImage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let videoCapture = videoCapture else {return}
        videoCapture.startCapture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let videoCapture = videoCapture else {return}
        videoCapture.resizePreview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let videoCapture = videoCapture else {return}
        videoCapture.stopCapture()
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation
    {
        return UIStatusBarAnimation.slide
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true;
    }

    func predict2(inputImage: CIImage)
    {

        // モデルのリクエストを作り、予測結果が帰ってきたとき結果に表示する
        let request = VNCoreMLRequest(model: mlModel) {
            request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                return
            }
            // バックグラウンドで処理が終わった時表示
            DispatchQueue.main.async {
                self.predictLabel.text = ""
                for result in results {
                    let label = result.identifier.components(separatedBy: ",")
                    let prob = result.confidence
                    // 確率が10%以上のものをテキストビューに追加する
                    // 結果は配列で返却されるので、1件目を画面に表示する
                    if prob >= 0.1 {
                        self.predictLabel.text = label[0] + "\n" + String(format: "%.1f", prob * 100) + "%"
                    }
                }
            }
        }
        


        let imageHandler = VNImageRequestHandler(ciImage: inputImage)
        


        do {
            // 画像予測を実行する
            try imageHandler.perform([request])
        } catch {
            print("エラー\(error)")
        }
    }
    

}

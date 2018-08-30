//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by kuniaki hamamoto on 2018/07/11.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var ivCaptureImage: UIImageView!
    @IBOutlet weak var tvResult: UITextView!
    
    // イメージピッカー
    var imagePicker: UIImagePickerController!
    
    private var mlModel : VNCoreMLModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // 学習データの読み込み
        mlModel = CoreMLUtility.getModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cameraRollButtonAction(_ sender: Any) {
        // カメラロールを表示する
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        // カメラを起動する
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // カメラロールを閉じる
        imagePicker.dismiss(animated: true, completion: nil)
        // 選択した画像があればイメージビューに表示する
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        ivCaptureImage.image = image
        
        predict(InputImage: image)
    }
    
    // 画像を予測する
    func predict(InputImage: UIImage) {
        tvResult.text = "解析中..."

        // モデルのリクエストを作り、予測結果が帰ってきたとき結果に表示する
        let request = VNCoreMLRequest(model: mlModel) {
            request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                return
            }
            // バックグラウンドで処理が終わった時表示
            DispatchQueue.main.async {
                self.tvResult.text = ""
                var resultStr = ""
                for result in results {
                    let label = result.identifier
                    let prob = result.confidence
                    // 確率が1%以上のものをテキストビューに追加する
                    if prob >= 0.01 {
                        // 確率が5%以上のものをテキストビューに追加する
                        resultStr = resultStr + label + "\t" + String(format: "%.1f", prob * 100) + "%\n\n"
                        self.tvResult.text = resultStr
                        
                    }
                }
            }
        }
        // 画像を学習モデルに渡せる形式へ変換する
        guard let ciImage = CIImage(image: InputImage) else {
            return
        }
        let imageHandler = VNImageRequestHandler(ciImage: ciImage)
        // 画像予測をバックグラウンドで処理する
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                // 画像予測を実行する
                try imageHandler.perform([request])
            } catch {
                print("エラー\(error)")
            }
        }
    }
    
    @IBAction func returnTop(segue : UIStoryboardSegue) {
        
    }
    
}


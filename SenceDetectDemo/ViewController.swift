//
//  ViewController.swift
//  SenceDetectDemo
//
//  Created by e趣 on 2017/6/8.
//  Copyright © 2017年 Jaye. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var sence     : UILabel!
    @IBOutlet weak var confidence: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func chooseImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        sence.text = "Analyzing Image…"
        
        guard let uiImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else { fatalError("no image from image picker") }
        
        guard let imageURL = info[UIImagePickerControllerImageURL] as? URL
            else{fatalError("error")}
        
        // Show the image in the UI.
        imageView.image = uiImage
        
        do {
            let model   = try VNCoreMLModel(for: GoogLeNetPlaces().model)
            let request = VNCoreMLRequest(model: model, completionHandler: resultsHandler)
            let handler = VNImageRequestHandler(url: imageURL)
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
    func resultsHandler(request: VNRequest, error: Error?) {
        
        guard let results = request.results as? [VNClassificationObservation]
            else { fatalError("error") }
        guard let best = results.first
            else { fatalError("error") }
        
        sence.text      = best.identifier
        confidence.text = "\(best.confidence)"
        
        for classification in results {
            print(classification.identifier,
                classification.confidence)
        }
    }
    
}


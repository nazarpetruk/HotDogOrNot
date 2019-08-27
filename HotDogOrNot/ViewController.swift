//
//  ViewController.swift
//  HotDogOrNot
//
//  Created by Nazar Petruk on 27/08/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: false, completion: nil)
    }
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userPickedImage
            guard let ciImage = CIImage(image: userPickedImage) else{
                fatalError("Couldn't convert Image to CIImage")
            }
            detectImage(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    func detectImage (image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("Model failed")
        }
        let request = VNCoreMLRequest(model: model){
            (request, error)in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model failed in Image Proces Rec.")
            }
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "It's a HotDog!"
                }else{
                    self.navigationItem.title = "Not a HodDog!"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
           try handler.perform([request])
        }catch{
            print(error)
        }
    }


}


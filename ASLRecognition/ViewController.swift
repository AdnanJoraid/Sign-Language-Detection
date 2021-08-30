//
//  ViewController.swift
//  ASLRecognition
//
//  Created by Adnan Joraid on 2021-08-30.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageViewBackground: UIImageView!
    let imagePicker = UIImagePickerController(
    )
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageViewBackground.image = userPickedImage//replace the defaul image view with the image that has been picked by the user.
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert user picked image to ciimage")
            }
            
            detect(image: ciimage)
            
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage){
        //loading up the model.
        guard let model =  try? VNCoreMLModel(for: ASLClassifier().model) else {
            fatalError("Loding CoreML Model Failed.")
        }
        let request = VNCoreMLRequest(model: model) {(request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Error. Could not convert Model.")
            }
            //getting the first result with the highest confidence rate.
            if let result = results.first {
                if result.identifier.contains("A"){
                    self.navigationItem.title = "A!"
                    
                }else if result.identifier.contains("B"){
                    self.navigationItem.title = "B"
                }else if result.identifier.contains("C"){
                    self.navigationItem.title = "C"
                }else if result.identifier.contains("D"){
                    self.navigationItem.title = "D"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }catch {
            print(error)
        }
    }
    
    
    
    @IBAction func onPressCameraButton(_ sender: UIBarButtonItem) {
        ///will be responsibe for handling events when the camera button is clicked.
        present(imagePicker, animated: true, completion: nil) //when the camera button is cliked, present the imagePicker allowing users to take images
    }
    
}


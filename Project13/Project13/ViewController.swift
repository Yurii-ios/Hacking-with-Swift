//
//  ViewController.swift
//  Project13
//
//  Created by Yurii Sameliuk on 15/05/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var filterName: UILabel!
    
    var currentImage: UIImage!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Instafilter"//"YACFFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(importPicture))
        ImageView.alpha = 0
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone") // filtr efekta sepii
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        dismiss(animated: true, completion: nil)
       
            currentImage = image

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: UIAlertAction.Style.default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: UIAlertAction.Style.default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: UIAlertAction.Style.default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: UIAlertAction.Style.default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: UIAlertAction.Style.default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: UIAlertAction.Style.default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: UIAlertAction.Style.default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
        present(ac, animated: true, completion: nil)
        
        // dlia ipad
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else {return}
        guard let actionTitle = action.title else {return}
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        filterName.text = actionTitle
        applyProcessing()
    }
    
    @IBAction func save(_ sender: UIButton) {
        if ImageView.image != nil {
        guard let image = ImageView.image else {return}
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            let ac = UIAlertController(title: "Please choise your image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            ac.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            present(ac, animated: true, completion: nil)
            
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.backgroundColor = .gray
                popoverController.sourceRect = sender.bounds
            }
        }
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        
         applyProcessing()
    }
    
    func  applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else {return}
        
        //currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        // cimage -> cgimage
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            // cgimage -> uiimage
            let processedImage = UIImage(cgImage: cgImage)
            ImageView.alpha = 1
               ImageView.image = processedImage
                
                
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: UIAlertController.Style.alert)
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
present(ac, animated: true, completion: nil)
        }
    }
}


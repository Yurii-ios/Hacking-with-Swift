//
//  ViewController.swift
//  ConsolidationX
//
//  Created by Yurii Sameliuk on 22/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    var images: UIImage?
    var topText: String?
    var bottomText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        addImageNavButton()
        
    }
    fileprivate func addImageNavButton() {
        let addImage = UIBarButtonItem(title: "Add Image", style: .plain, target: self, action: #selector(importImage))
        let addText = UIBarButtonItem(title: "Add Text", style: .plain, target: self, action: #selector(addTexts))
        let send = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.rightBarButtonItems = [addImage, addText]
        navigationItem.leftBarButtonItem = send
    }
    
    @objc fileprivate func share() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {return}
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    
  @objc fileprivate func importImage() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.sourceType = .photoLibrary
    picker.delegate = self
    present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true, completion: nil)
        images = image
        drawImagesAndText()
        let ac = UIAlertController(title: "Alert", message: "If you want add text please press button \"add Text\" ", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
    
  fileprivate func drawImagesAndText() {
           // sozdaem cholst dlia risowanija
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
           
           let image = renderer.image { (ctx) in
            images?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height))
               // awesome drawing code
               let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 36), .paragraphStyle: paragraphStyle, .foregroundColor : UIColor.white]
            if let topText = topText {
               let attributeString = NSAttributedString(string: topText, attributes: attrs)
            attributeString.draw(with: CGRect(x: 0, y: 5, width:imageView.frame.width, height: 200), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
            }
            if let bottomText = bottomText {
                let attributeString = NSAttributedString(string: bottomText, attributes: attrs)
                attributeString.draw(with: CGRect(x: 0, y: imageView.frame.height - 65, width:imageView.frame.width, height: 200), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
            }
           }
        imageView.image = image
       }
    
    @objc fileprivate func addTexts() {
        let ac = UIAlertController(title: "Set Text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let topText = UIAlertAction(title: "Top", style: .default) { [weak self, weak ac](alert) in
            guard let text = ac?.textFields?[0].text else { return }
            self?.topText = text
            self?.drawImagesAndText()
        
        }
        let bottomText = UIAlertAction(title: "Bottom", style: .default) { [weak self, weak ac] (action) in
            guard let text = ac?.textFields?[0].text else { return }
            self?.bottomText = text
            self?.drawImagesAndText()

        }
       
        print(self.bottomText)
        ac.addAction(topText)
        ac.addAction(bottomText)
        present(ac, animated: true, completion: nil)
    }
}


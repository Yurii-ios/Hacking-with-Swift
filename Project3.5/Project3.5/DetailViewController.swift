//
//  DetailViewController.swift
//  Project3.5
//
//  Created by Yurii Sameliuk on 16/04/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
     var selectedImage: UIImage?
    var selectedNamed: String?
    @IBOutlet var detailNameLabel: UILabel!
    @IBOutlet var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = selectedImage, let named = selectedNamed {
            detailImageView.image = image
            detailNameLabel.text = named
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(sendCountriesSelector))
    }
    @objc func sendCountriesSelector() {
        guard let image = detailImageView.image?.jpegData(compressionQuality: 0.8) else { return }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
        
    }
}

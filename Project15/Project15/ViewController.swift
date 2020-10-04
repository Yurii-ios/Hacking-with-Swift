//
//  ViewController.swift
//  Project15
//
//  Created by Yurii Sameliuk on 20/05/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var imageView: UIImageView!
    var currentAnimation = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }

    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true
        
        // start animation block
       // UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
        switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2) // yweli4iwaet izobraženie
                break
            case 1:
                self.imageView.transform = .identity // ydaliaet predidys4ie
            case 2:
                self.imageView.transform = .init(translationX: -256, y: -256) // peremes4aet w werchnij lewuj ygol
            case 3:
                self.imageView.transform = .identity
            case 4:
                self.imageView.transform = .init(rotationAngle: CGFloat.pi)
            case 5:
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
            default: break
            }
        }) { (finished) in
            sender.isHidden = false
        }
        
        
        currentAnimation += 1
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
    
}

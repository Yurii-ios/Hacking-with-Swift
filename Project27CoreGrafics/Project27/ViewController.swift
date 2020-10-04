//
//  ViewController.swift
//  Project27
//
//  Created by Yurii Sameliuk on 20/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        draw()
    }
    
    @IBAction func redrawTapped(_ sender: UIButton) {
        currentDrawType += 1
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        case 7:
            draw()
        default:
            break
        }
    }
    
    func drawRectangle() {
        // sozdaem cholst dlia risowanija
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            // awesome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            let rect = CGRect(x:140, y: 140, width: 70, height: 90)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            //ctx.cgContext.addRect(rectangle)
            ctx.cgContext.addRects([rectangle, rect])
            ctx.cgContext.drawPath(using: CGPathDrawingMode.fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        // sozdaem cholst dlia risowanija
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            // awesome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            //let rect = CGRect(x:140, y: 140, width: 70, height: 90)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            //ctx.cgContext.addRect(rectangle)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: CGPathDrawingMode.fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCheckerboard() {
        // sozdaem cholst dlia risowanija
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            // awesome drawing code
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for column in 0 ..< 8 {
                    if (row + column) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: column * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        // sozdaem cholst dlia risowanija
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            // awesome drawing code
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
                ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
                ctx.cgContext.strokePath()
            }
        }
        
        imageView.image = image
        
    }
    
    func drawLines() {
        // sozdaem cholst dlia risowanija
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            // awesome drawing code
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 350{
                ctx.cgContext.rotate(by: .pi / 2)
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 5))
                }
                length *= 0.99
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        // sozdaem cholst dlia risowanija
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            // awesome drawing code
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 36), .paragraphStyle: paragraphStyle]
            let string = "The best lines"
            let attributeString = NSAttributedString(string: string, attributes: attrs)
            attributeString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = image
    }
    
    func drawEmoji() {
        // sozdaem cholst dlia risowanija
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            // awesome drawing code 🙂
            let rect = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 10, dy: 10)
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setLineWidth(2)
            ctx.cgContext.addEllipse(in: rect)
            ctx.cgContext.drawPath(using: .fillStroke)
            // eyes
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            let eyeRect1 = CGRect(x: 128, y: 170, width: 20, height: 20)
            let eyeRect2 = CGRect(x: 384, y: 170, width: 20, height: 20)
            ctx.cgContext.addEllipse(in: eyeRect1)
            ctx.cgContext.addEllipse(in: eyeRect2)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let arcRadius: Double = 220
            
            let arcStartAngle = Measurement(value: 45, unit: UnitAngle.degrees).converted(to: .radians).value
            let arcEndAngle = Measurement(value: 135, unit: UnitAngle.degrees).converted(to: .radians).value
            print(" arcStartAngle: \(arcStartAngle)")
            print(" arcEndAngle: \(arcEndAngle)")
            ctx.cgContext.addArc(center: CGPoint(x: 256, y: 200), radius: 220, startAngle: CGFloat(0.79), endAngle: CGFloat(2.4), clockwise: false)
            
            //             ctx.cgContext.addArc(center: CGPoint(x: 256, y: 220), radius: CGFloat(arcRadius),  startAngle: CGFloat(arcStartAngle), endAngle: CGFloat(arcEndAngle), clockwise: false)
            
            ctx.cgContext.drawPath(using: .stroke)
            
        }
        
        imageView.image = image
    }
    
    func draw() {
        // sozdaem cholst dlia risowanija
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { (ctx) in
            // awesome drawing code
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.alignment = .center
//            let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 36), .paragraphStyle: paragraphStyle]
//            let string = "TWIN"
//            let attributeString = NSAttributedString(string: string, attributes: attrs)
//            attributeString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
            
            let length: CGFloat = 256
            ctx.cgContext.move(to: CGPoint(x: 60, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 5, y: 50))
            ctx.cgContext.move(to: CGPoint(x: 35, y: 50))
            ctx.cgContext.addLine(to: CGPoint(x: 35, y: 100))
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
        }
        
        imageView.image = image
    }
}


//
//  ViewController.swift
//  Project3.5
//
//  Created by Yurii Sameliuk on 16/04/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var test = ["Test", "test"]
    var countries = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("3x.png"){
                countries.append(item)
            }
        }
       
        print(countries)
    
    }
//    func resourcesFM () {
//        let fm = FileManager.default
//        let path = Bundle.main.resourcePath!
//        let items = try! fm.contentsOfDirectory(atPath: path)
//
//        for item in items {
//            if item.hasSuffix("png"){
//                countries.append(item)
//            }
//        }
//        print(countries)
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Image" , for: indexPath)
        cell.imageView?.image = UIImage(named:  countries[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "detail") as! DetailViewController
        vc.selectedImage = UIImage(named:  countries[indexPath.row])
        vc.selectedNamed = countries[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}


//
//  ViewController.swift
//  Project12
//
//  Created by Yurii Sameliuk on 11/05/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults =  UserDefaults.standard
        
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UseFaceID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        
        defaults.set("yurii", forKey: "name")
        defaults.set(Date(), forKey: "last run")
        
        let array = ["hello", "word"]
        defaults.set(array, forKey: "SavedArray")
        
        let dict = ["Name": "yurii", "Country": "PL"]
        defaults.set(dict, forKey: "SavedDictionary")
        
        let savedInt = defaults.integer(forKey: "Age")
        let savedBool = defaults.bool(forKey: "UseFaceID")
       
        let savedArray = defaults.object(forKey: "SavedArray") as? [String] ?? [String]()
        let savedDictionary = defaults.object(forKey: "SavedDictionary") as? [String: String] ?? [String: String]()
        
    
    }


}


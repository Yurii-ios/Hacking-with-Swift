//
//  ViewController.swift
//  Project18Debaging
//
//  Created by Yurii Sameliuk on 27/05/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       assert(1 == 1, "Math failture!")
        assert(1 == 2, "Math failture!")
        
        //assert(myReallySlowMethod() == true, "the slow method return false")
        
        for i in 1...100 {
            print(i)
        }
    }


}


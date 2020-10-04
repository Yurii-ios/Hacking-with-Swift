//
//  ViewController.swift
//  ConsolidationsVI
//
//  Created by Yurii Sameliuk on 22/05/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
var country = [Countries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=Kyiv&format=json"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
                print(data)
                parse(json: data)
                return
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        do {
            let jsonData = try decoder.decode(Result.self, from: json)
            country = jsonData.query.search
            print(jsonData)
            
            tableView.reloadData()
        } catch {
            print("Error to load data.")
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return country.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = country[indexPath.row].title
        return cell
    }
    
}


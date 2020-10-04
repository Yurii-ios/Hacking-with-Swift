//
//  ViewController.swift
//  Project6c
//
//  Created by Yurii Sameliuk on 25/04/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightBarButtonItem()
        leftBarButtonItems()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        
        cell.textLabel?.text = shoppingList[indexPath.row]
        
        return cell
    }
    
    
    
    func rightBarButtonItem () {
             navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addNewTaskToBuy))
        }
    
    @objc func addNewTaskToBuy() {
        let ac = UIAlertController(title: "Add new element to ShoppingList", message: nil, preferredStyle: UIAlertController.Style.alert)
        ac.addTextField()
        
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            [weak self, weak ac] action in
            
            guard let purchase = ac?.textFields?[0].text else {return}
            self?.add(purchase)
            }
        ac.addAction(action)
        present(ac, animated: true, completion: nil)
    }
    
    func add(_ newElement: String) {
        let lowerNewElement = newElement.lowercased()
        shoppingList.insert(lowerNewElement, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    func leftBarButtonItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(deleteAll))
    }
    
    @objc func deleteAll () {
        shoppingList.removeAll()
        tableView.reloadData()
        
    }
    
}


//
//  ViewController.swift
//  ConsolidationsV
//
//  Created by Yurii Sameliuk on 13/05/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var persons = [Person]()
    var person1: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(makePhoto))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Rename", style: UIBarButtonItem.Style.plain, target: self, action: #selector(renamePhoto))
        
//        let item = ["Yurii", "Irina"]
//        person += item
        title = "Person Images"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let defaults = UserDefaults.standard
        if let savePersons = defaults.object(forKey: "persons") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                persons = try jsonDecoder.decode([Person].self, from: savePersons)
            } catch {
                print("Failed to load persons!")
            }
        }
    }
    
    @objc func renamePhoto() {
        let ac = UIAlertController(title: "Rename Photo", message: nil, preferredStyle: UIAlertController.Style.alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {  [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            //self?.newNameForImage = newName
            //self?.person1?.name = newName
            self?.tableView.reloadData()
            
        })
        ac.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) {
            [weak self] _ in
            self?.persons.removeAll(keepingCapacity: false)
            self?.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    @objc func makePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        guard let image = info[.editedImage] as? UIImage else {return}
            
        let imageName = UUID().uuidString
        
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.9) {
            try? jpegData.write(to: imagePath)
        }
        
        
        let person = Person(image: imageName, name: "name")
        persons.append(person)
        save()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func rename() {
        
    }
    
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        return path[0]
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = persons[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let person = persons[indexPath.item]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let path = getDocumentDirectory().appendingPathComponent(person.image)
        
        vc.detail = String(path.path)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func save () {
        let jsonEncoder = JSONEncoder()
        if let saveData = try? jsonEncoder.encode(persons) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "persons")
        } else {
            print("Fail to save persons!.")
        }
    }
}


//
//  ViewController.swift
//  Tableview
//
//  Created by TechCampus on 8/13/20.
//  Copyright © 2020 TechCampus. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
        
    var peopleArray: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Names"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            peopleArray = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("error occured: \(error.userInfo)")
        }
    }
    
    @IBAction func addNotesBtnClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Enter Name", message: "Add Name here!", preferredStyle: .alert)
        
        let savebutton = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let textfield = alert.textFields?.first, let nameToSave = textfield.text else { return }
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        alert.addTextField()
        alert.addAction(savebutton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: context) else { return }
        let person = NSManagedObject(entity: entity, insertInto: context)
        person.setValue(name, forKey: "name")
        do {
            try context.save()
            peopleArray.append(person)
        } catch let error as NSError {
            print("error occured, cannot save name: \(error.userInfo)")
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let person = peopleArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
    }
    
    //i can write what ever i want, only comment, xcode doesnt read it
    
    
}


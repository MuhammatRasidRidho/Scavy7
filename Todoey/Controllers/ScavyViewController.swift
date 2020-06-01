//
//  ScavyViewController.swift
//  Scavy
//
//  Created by Muhammat Rasid Ridho on 01/06/20.
//  Copyright © 2020 Muhammat Rasid Ridho All rights reserved.
//

import UIKit
import CoreData

class ScavyViewController: UITableViewController {

    
    var scavies = [Scavy]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadScavies()
        
    }

    
    //Mark: - Table View DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return scavies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScavyCell", for: indexPath)
        
        cell.textLabel?.text = scavies[indexPath.row].name
        
        return cell
    }

    //Mark: - Table View Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPertemuans", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CategoryViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedScavy = scavies[indexPath.row]
        }
    }

        
    //Mark: - Data Manipulation Methods
    
    func saveScavies(){
        do {
            try context.save()
        } catch {
            print("Error simpan Pelajaran \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadScavies() {
        
        let request : NSFetchRequest<Scavy> = Scavy.fetchRequest()
        
        do {
            scavies = try context.fetch(request)
        } catch {
            print("Error ketika munculkan Pelajaran \(error)")
        }
        
        tableView.reloadData()  
    }

    
    //Mark: - Add New Scavy
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Tambah Pelajaran", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Tambah", style: .default) { (action) in
            
            let newScavy = Scavy(context: self.context)
            newScavy.name = textField.text!
            
            self.scavies.append(newScavy)
            
            self.saveScavies()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Tambah Pelajaran Baru"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

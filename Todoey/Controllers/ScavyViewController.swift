//
//  ScavyViewController.swift
//  Scavy
//
//  Created by Muhammat Rasid Ridho on 01/06/20.
//  Copyright © 2020 Muhammat Rasid Ridho All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblNama: UILabel!
    @IBOutlet weak var lblKelas: UILabel!
    @IBOutlet weak var lblSemester: UILabel!
}



class ScavyViewController: UITableViewController {

    
    
    var scavies = [Scavy]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        loadScavies()
        
    }

    
    //MARK: - Table View DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(scavies.count)
        return scavies.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScavyCell", for: indexPath) as! CategoryTableViewCell
        let category = scavies[indexPath.row]
        
        cell.lblNama?.text = category.name
        cell.lblKelas?.text = category.kelas
        cell.lblSemester?.text = category.semester
        
        
//        cell.textLabel?.text = scavies[indexPath.row].kelas
//        cell.textLabel?.text = scavies[indexPath.row].semester
        
        return cell
    }

    //MARK: - Table View Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPertemuans", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CategoryViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedScavy = scavies[indexPath.row]
        }
    }

        
    //MARK: - Data Manipulation Methods
    
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

    
    //MARK: - Add New Scavy
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        var textField2 = UITextField()
        var textField3 = UITextField()
        
        let alert = UIAlertController(title: NSLocalizedString("Add Subject", comment: ""), message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: NSLocalizedString("Add", comment: ""), style: .default) { (action) in
            
            let newScavy = Scavy(context: self.context)
            newScavy.name = textField.text!
            newScavy.kelas = textField2.text!
            newScavy.semester = textField3.text!
            
            self.scavies.append(newScavy)
            
            self.saveScavies()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = NSLocalizedString("Add New Subject", comment: "") 
        }
        
        alert.addTextField { (field2) in
            
            textField2 = field2
            textField2.placeholder = NSLocalizedString("Add New Class", comment: "")
        }
        
        alert.addTextField { (field3) in
            textField3 = field3
            textField3.placeholder = NSLocalizedString("Add New Semester", comment: "")
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    // MARK: - Delete Slider
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")
        
        self.context.delete(scavies[indexPath.row])
        self.scavies.remove(at: indexPath.row)
        
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        self.saveScavies()
        
      }
        tableView.reloadData()
    }
}



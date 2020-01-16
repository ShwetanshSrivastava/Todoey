//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shwetansh Srivastava on 13/12/19.
//  Copyright © 2019 Shwetansh Srivastava. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navBar = navigationController?.navigationBar {
            navBar.backgroundColor = UIColor(hexString: "1D9BF6")
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]
        }
    }
    // MARK: - Table view data source
 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()
        let alert = UIAlertController(title: "Enter New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add a new Category", style: .default) { (alertAction) in

            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.saveData(newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Books, Games, etc.."
            textField = alertTextField
        }
        present(alert,animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories"
        let color = UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6")
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
        return cell
    }
    
    
    //MARK: - Table View Delegates
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
 
    func saveData(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("can't save data \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Update Data Model
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("error \(error)")
            }
        }
    }
    
    func loadData() {
        categories = realm.objects(Category.self)
    }
}

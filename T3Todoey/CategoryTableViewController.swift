//
//  CategoryTableViewController.swift
//  T3Todoey
//
//  Created by Trung Trinh on 4/5/18.
//  Copyright © 2018 Trung Trinh. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryTableViewController: UITableViewController {
    
    var viewContext: NSManagedObjectContext!
    var categories = [Category]()
    
    //MARK: - Internal methods
    @objc func addCategory(){
        let ac = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Enter new category"
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let category = Category(context: self.viewContext)
            category.name = ac.textFields?.first?.text ?? ""
            category.createdAt = Date()
            category.color = UIColor.randomFlat.hexValue()
            self.categories.append(category)
            self.saveContext()
            self.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            ac.dismiss(animated: true, completion: nil)
        }))
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - Data manipulation methods
    private func saveContext(){
        if viewContext.hasChanges{
            do{
                try viewContext.save()
            }catch{
                print("Error when saving data")
            }
        }
    }
    
    private func loadCategories(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try viewContext.fetch(request)
            tableView.reloadData()
        }catch{
            print("Error when loading data")
        }
    }

    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategory))
        tableView.separatorStyle = .none

        viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadCategories()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemSegue", let vc = segue.destination as? ItemTableViewController, let selectedIndex = tableView.indexPathForSelectedRow {
            vc.selectedCategory = categories[selectedIndex.row]
        }
    }

    //MARK: - UITableViewController
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name ?? ""
        cell.detailTextLabel?.text = dateTimeFormattedAsTimeAgo(date: category.createdAt! as NSDate)
        cell.backgroundColor = UIColor(hexString: category.color ?? UIColor.white.hexValue())
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            viewContext.delete(categories[indexPath.row])
            categories.remove(at: indexPath.row)
            saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
    
}

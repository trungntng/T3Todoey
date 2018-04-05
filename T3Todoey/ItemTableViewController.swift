//
//  ItemTableViewController.swift
//  T3Todoey
//
//  Created by Trung Trinh on 4/5/18.
//  Copyright © 2018 Trung Trinh. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class ItemTableViewController: UITableViewController {
    
    var viewContext: NSManagedObjectContext!
    var items = [Item]()
    var selectedCategory: Category?
    
    //MARK: - Internal methods
    @objc func addItem(){
        let ac = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Enter new item"
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let item = Item(context: self.viewContext)
            item.title = ac.textFields?.first?.text ?? ""
            item.isChecked = false
            item.category = self.selectedCategory
            self.items.append(item)
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
        if viewContext.hasChanges {
            do{
                try viewContext.save()
            }catch{
                print("Error when saving data")
            }
        }
    }
    
    private func loadItems(){
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "category.name == %@", selectedCategory?.name ?? "")
        request.predicate = predicate
        do{
            items = try viewContext.fetch(request)
            tableView.reloadData()
        }catch{
            print("Error when loading data")
        }
    }

    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        tableView.separatorStyle = .none
        
        viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            title = selectedCategory?.name ?? ""
            guard let navBar = navigationController?.navigationBar else {return}
            
            navBar.barTintColor = UIColor(hexString: colorHex)
            navBar.tintColor = ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true)]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let originalColor = UIColor(hexString: "4E98F1")!
        guard let navBar = navigationController?.navigationBar else {return}
        
        navBar.barTintColor = originalColor
        navBar.tintColor = ContrastColorOf(originalColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(originalColor, returnFlat: true)]
    }

    //MARK: - UITableViewController
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isChecked ? .checkmark : .none
        
        if let color = UIColor(hexString: item.category?.color ?? UIColor.white.hexValue())?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(items.count)) {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isChecked = !items[indexPath.row].isChecked
        saveContext()
        tableView.reloadData()
    }
}

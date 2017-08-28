//
//  ExpensesViewController.swift
//  CalcNYC
//
//  Created by Justin Kim on 8/25/17.
//  Copyright © 2017 Justin Kim. All rights reserved.
//

import Foundation
import UIKit

class ExpensesViewController: UIViewController {
    
    @IBOutlet weak var expensesTableView: UITableView!
    
    @IBOutlet weak var budgetAmt: UILabel!
    
    @IBAction func newBudget(_ sender: Any) {
        self.presentAlert()
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
//        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)

        
    }
    
    var items = [Item](){
        didSet{
            self.expensesTableView.reloadData()
        }
    }
    
    var budget: Budget?
    
    func presentAlert() {
        let alertController = UIAlertController(title: "New Budget", message: "Please write your budget amount:", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Budget Amount"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] (_) in
            if (alertController.textFields?[0].text) != nil{
                guard let text = alertController.textFields?[0].text else{
                    self?.alert(message: "Please type numbers and only numbers in this field")
                    return
                }
                let budget = self?.budget ?? CoreDataHelper.newBudget()
                budget.newBudget = text
                CoreDataHelper.save()
                let bud = budget.newBudget
                self?.budgetAmt.text = String(format: "$%.2f", bud!)
            }
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expensesTableView.tableFooterView = UIView()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let budget = budget {
            // 2
            budgetAmt.text = budget.newBudget
                   } else {
            // 3
            budgetAmt.text = "$0.00"

    }
    


    
    
}
}

extension ExpensesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell
        cell.delegate = self as? CellDelegate
        configure(cell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configure(cell: Cell, atIndexPath indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        cell.itemName.text = item.itemName
        cell.price.text = item.price
//        cell.Date.text = item.creationTime
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            CoreDataHelper.delete(item: items[indexPath.row])
            
            items = CoreDataHelper.retrieveItems().reversed()
        }
    }
    
    func alert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }


    
}



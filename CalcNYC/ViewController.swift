//
//  ViewController.swift
//  CalcNYC
//
//  Created by Justin Kim on 8/24/17.
//  Copyright © 2017 Justin Kim. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var tax: Double = 0.00
    var pickViewChoice: String!
    var selectedRow = 0
    
    var item: Item?
    
    enum taxType: String {
        case General = "General"
        case Clothing = "Clothing and Footwear"
    }
    
    
    let colors = ["\(taxType.General.rawValue)","\(taxType.Clothing.rawValue)"]

    
    @IBOutlet weak var listedPriceView: UITextField!
    @IBOutlet weak var actualPriceView: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var whatDidYouBuy: UITextField!
    
    @IBOutlet weak var salesTaxAmt: UITextField!
    
    @IBAction func calculateTax(_ sender: Any) {
        guard let text = listedPriceView.text,
            let listedPrice = Double(text)
            else{
                self.alert(message: "Please type in numbers and only numbers in this field")
                return
        }
        switch self.selectedRow {
        case 0 : //General
            tax = 0.08875
            
        case 1 : //Clothes and Footwear
            if listedPrice >= Double(110){
                tax = 0.085
            } else {
                tax = 0.00
                self.alert(message: "According to New York City law, clothes and footwear under the price of $110 are exempt from sales tax. Congrats!")
            }
        default:
            return
        }
        
        let roundedPriceAmount = round(100 * listedPrice) / 100
        let salesTaxAmount = roundedPriceAmount * tax
        let actualPrice = roundedPriceAmount + salesTaxAmount
        
        if (!listedPriceView.isEditing){
            listedPriceView.text = String(format: "%.2f", listedPrice)
        } else{
            actualPriceView.text = ""
        }
        actualPriceView.text = String(format: "$%.2f", actualPrice)
        salesTaxAmt.text = String(format: "$%.2f", salesTaxAmount)
        
        let item = self.item ?? CoreDataHelper.newItem()
        item.itemName = whatDidYouBuy.text
        item.price = actualPriceView.text
        item.creationTime = Date() as NSDate
        CoreDataHelper.save()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func info(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "info") as! InfoViewController
        self.navigationController?.show(controller, sender: nil)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}



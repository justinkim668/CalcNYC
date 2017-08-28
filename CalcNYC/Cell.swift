//
//  Cell.swift
//  CalcNYC
//
//  Created by Justin Kim on 8/25/17.
//  Copyright © 2017 Justin Kim. All rights reserved.
//

import Foundation
import UIKit

protocol CellDelegate: class {
    func didTapFollowButton(_ followButton: UIButton, on cell: Cell)
}

class Cell: UITableViewCell{
    
    weak var delegate: CellDelegate?
    
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var apply: UIButton!
   
    
    @IBAction func apply(_ sender: Any) {
        
    }
    
}

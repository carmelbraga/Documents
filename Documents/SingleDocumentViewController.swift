//
//  SingleDocumentViewController.swift
//  Documents
//
//  Created by Carmel Braga on 8/30/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//

import UIKit

class SingleDocumentViewController: UIViewController {
    
    var document: Document?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextField.text = document?.information
        
        nameTextField.text = document?.name
        
        title = document?.name

        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func newName(_ sender: Any) {
        title = nameTextField.text
    }
    
    @IBAction func save(_ sender: Any) {
        DocumentInfo.save(name: nameTextField.text ?? "", information: descriptionTextField.text)
        self.navigationController?.popViewController(animated: true)

    }
    
}

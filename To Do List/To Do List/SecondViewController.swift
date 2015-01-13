//
//  SecondViewController.swift
//  To Do List
//
//  Created by Dominic Wong on 13/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var toDoItem: UITextField!
    @IBAction func addItem(sender: AnyObject) {
        if toDoItem.text != "" {
            toDoItems.append(toDoItem.text)
            
            let fixedToDoItems = toDoItems
            NSUserDefaults.standardUserDefaults().setObject(fixedToDoItems, forKey: "toDoItems")
            NSUserDefaults.standardUserDefaults().synchronize()
                        
            toDoItem.text = ""
        }
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

}


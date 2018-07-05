//
//  LoginViewController.swift
//  Toserba
//
//  Created by MTMAC18 on 05/07/18.
//  Copyright © 2018 Wisnu Anggoro. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginTapped(_ sender: UIButton) {
        let email = emailText.text
        let password = passwordText.text
        
        if (email == "" || password == "") {
            let alert = UIAlertController(title: "Email", message: "No email address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (response) in
                
            }))
            
            present(alert, animated: false, completion: nil)
        }
        
        
    }
    
    func doSomething(action: UIAlertAction) {
        //Use action.title
    }
}


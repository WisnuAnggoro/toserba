//
//  LoginViewController.swift
//  Toserba
//
//  Created by MTMAC18 on 05/07/18.
//  Copyright © 2018 Wisnu Anggoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var credential: Credential?
    
    var canShopDisplayed = false

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // Login to server
        SVProgressHUD.show()
        login(email: email!, password: password!) { (result) in
            self.canShopDisplayed = result
            self.performSegue(withIdentifier: "loginToShop", sender: self)
            if(result) {
                print("login success")
            }
            else {
                print("login failed")
            }
            
            SVProgressHUD.dismiss()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "loginToShop" {
            if canShopDisplayed == false {
                return false
            }
        }
        
        return true
    }
    
    func login(email: String, password: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        var result = false
        
        let loginUrl = FirebaseService.shared.getLoginEndpoint()
        let url = FirebaseSensitiveData.shared.embedKey(toEndpoint: loginUrl)
        
        Alamofire.request(
            url,
            method: .post,
            parameters: ["email": email, "password": password, "returnSecureToken": true],
            encoding: JSONEncoding.default,
            headers: ["Content-Type": "application/json"]).responseData { (response) in
                
                // ------------ debug ------------
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
                // -------------------------------
                
                if let httpStatusCode = response.response?.statusCode {
                    if httpStatusCode == 200 {
                        let json: JSON = JSON(response.result.value!)
                        
                        // Create new credential
                        self.credential = Credential()
                        self.credential?.kind = json["kind"].stringValue
                        self.credential?.localId = json["localId"].stringValue
                        self.credential?.email = json["email"].stringValue
                        self.credential?.displayName = json["displayName"].stringValue
                        self.credential?.idToken = json["idToken"].stringValue
                        self.credential?.refreshToken = json["refreshToken"].stringValue
                        self.credential?.expiresIn = json["expiresIn"].stringValue
                        
                        result = true
                    }
                    else {
                        let alert = UIAlertController(title: "Login Failed", message: "Unknown email or password", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (response) in
                            
                        }))
                        
                        self.present(alert, animated: false, completion: nil)
                    }
                }
                
                completionHandler(result)
            }
    }
}


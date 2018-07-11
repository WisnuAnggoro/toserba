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
    var categories: [Category] = []
    
    var canShopDisplayed = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onLoginTapped(_ sender: UIButton) {
        let email = emailText.text
        let password = passwordText.text
        
        if (email == "" || password == "") {
            DisplayOKOnlyDialogBox(title: "Empty Form", message: "Email or password cannot be blank")
            return
        }
        
        // Login to server
        SVProgressHUD.show(withStatus: "Login to server")
        login(email: email!, password: password!) { (result) in
            if(result) {
                SVProgressHUD.dismiss()
                SVProgressHUD.show(withStatus: "Fetch data from server")
                self.getCategories(completionHandler: { (result) in
                    if result {
                        self.canShopDisplayed = result
                        self.performSegue(withIdentifier: "loginToShop", sender: self)
                    }
                    
                    SVProgressHUD.dismiss()
                })
            }
            
            return
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
                
                self.DebugAlamofireResponse(response: response)
                
                if let httpStatusCode = response.response?.statusCode {
                    if httpStatusCode == 200 {
                        let json = JSON(response.result.value!)
                        
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
                        self.DisplayOKOnlyDialogBox(
                            title: "Login Failed",
                            message: "Unknown email or password",
                            animated: true)
                    }
                }
                
                completionHandler(result)
            }
    }
    
    func getCategories(completionHandler: @escaping (_ success: Bool) -> Void) {
        guard let idToken = credential?.idToken else {
            return
        }
        var result = false
        let url = FirebaseService.shared.getCategoriesEndpoint(withIdToken: idToken)
        
        Alamofire.request(url).responseData { (response) in
            
            if let httpStatusCode = response.response?.statusCode {
                if httpStatusCode == 200 {
                    let json = JSON(response.result.value!)
                    
                    if let jsonCategories = json["categories"].array {
                        result = true
                        
                        for category in jsonCategories {
                            let c = Category()
                            c.id = category["id"].int!
                            c.name = category["name"].rawString()!
                            
                            var products: [Product] = []
                            if let jsonProducts = category["products"].array {
                                for product in jsonProducts {
                                    let p = Product()
                                    p.name = product["name"].rawString()!
                                    p.price = product["price"].int!
                                    products.append(p)
                                }
                            }
                            c.products = products
                            
                            self.categories.append(c)
                        }
                    }
                }
            }
            
            completionHandler(result)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if canShopDisplayed == true {
            if segue.identifier == "loginToShop" {
                let nav = segue.destination as! UINavigationController
                let vc = nav.topViewController as! ShopTableViewController
                vc.categories = categories
            }
        }
    }
    
    func DisplayOKOnlyDialogBox(title: String, message: String, animated : Bool = false) {
        // Dismiss progress hud if any
        SVProgressHUD.dismiss()
        
        // Display error message
        let alert = DialogBoxService.shared.OKOnly(
            withTitle: title,
            andMessage: message)
        self.present(alert, animated: animated, completion: nil)
    }
    
    func DebugAlamofireResponse(response: DataResponse<Data>) {
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
    }
}


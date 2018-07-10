//
//  DialogBoxService.swift
//  Toserba
//
//  Created by Wisnu Anggoro on 10/07/18.
//  Copyright © 2018 Wisnu Anggoro. All rights reserved.
//

import UIKit

class DialogBoxService {
    // Singleton
    private init(){}
    static let shared = DialogBoxService()
    
    // Static methods
    func OKOnly(withTitle title: String, andMessage message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return alert
    }
    
    
}

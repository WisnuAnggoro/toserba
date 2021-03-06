//
//  FirebaseService.swift
//  Toserba
//
//  Created by MTMAC18 on 06/07/18.
//  Copyright © 2018 Wisnu Anggoro. All rights reserved.
//

import Foundation

class FirebaseService {
    // Initialize Singleton
    private init(){}
    static let shared = FirebaseService()
    
    // Static data
    var identityToolkitBaseAddress = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/"
    let databaseBaseAddress = "https://" + FirebaseSensitiveData.shared.projectId + ".firebaseio.com/"
    
    // Static methods
    func getRegistrationEndpoint() -> String{
        return identityToolkitBaseAddress + "signupNewUser"
    }
    
    func getLoginEndpoint() -> String{
        return identityToolkitBaseAddress + "verifyPassword"
    }
    
    func getCategoriesEndpoint(withIdToken idToken: String) -> String {
        return databaseBaseAddress + "categories.json" + "?auth=" + idToken
    }
}

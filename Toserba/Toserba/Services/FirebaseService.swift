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
    private init(){
//        self.identityToolkitBaseAddress = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/"
    }
    static let shared = FirebaseService()
    
    // Static data
    var identityToolkitBaseAddress = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/"
    let databaseBaseAddress = "https://" + FirebaseSensitiveData.shared.projectId + "firebaseio.com/"
    
    func getRegistrationEndpoint() -> String{
        return identityToolkitBaseAddress + "signupNewUser"
    }
    
    func getLoginEndpoint() -> String{
        return identityToolkitBaseAddress + "verifyPassword"
    }
}

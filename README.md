# toserba
An app for consuming some available features in Swift

Please add a file named *FirebaseSensitiveData.swift* with the following code:
```swift
import Foundation

class FirebaseSensitiveData {
    // Initialize Singleton
    private init(){}
    static let shared = FirebaseSensitiveData()

    // Sensitive data
    let apiKey = "" // Provide Firebase Api Key
    let projectId = "" // Provide project ID to be included in database URL address

    // Methods
    func embedKey(toEndpoint endpoint: String) -> String{
        return endpoint + "?key=" + apiKey
    }
}
```

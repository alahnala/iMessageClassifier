//
//  ContactsManager.swift
//  ContactsTest
//
//  Created by Maxim Aleksa on 11/20/16.
//  Copyright © 2016 Maxim Aleksa. All rights reserved.
//

import Foundation
import Contacts

class ContactsManager {
    
    static let sharedManager = ContactsManager()
    let contactStore = CNContactStore()
    
    var contacts = [CNContact]()
    
    func findNameFor(phoneNumber: String) -> String? {
        for contact in contacts {
            for contactPhoneNumber in contact.phoneNumbers {
                
                let number = (contactPhoneNumber.value as CNPhoneNumber).stringValue
                let formattedNumber = String(number.characters.filter({ !["-", " ", " ", ".", "(", ")"].contains($0) }))
                // print(formattedNumber)
                
                // let countryCode = (contactPhoneNumber.value as CNPhoneNumber).value(forKey: "countryCode") as! String
                // print(countryCode)
                // let digits = (contactPhoneNumber.value as CNPhoneNumber).value(forKey: "digits") as! String
                // print(digits)
                
                if formattedNumber == phoneNumber {
                    return CNContactFormatter.string(from: contact, style: .fullName) ?? "No name"
                }
            }
        }
        // continue searching
        let nDigits = 10
        let trimmedPhoneNumber = phoneNumber.lastNCharacters(nDigits)
        for contact in contacts {
            for contactPhoneNumber in contact.phoneNumbers {
                
                let number = (contactPhoneNumber.value as CNPhoneNumber).stringValue
                let formattedNumber = String(number.characters.filter({ !["-", " ", " ", ".", "(", ")"].contains($0) })).lastNCharacters(nDigits)
                
                if formattedNumber == trimmedPhoneNumber {
                    return CNContactFormatter.string(from: contact, style: .fullName) ?? "No name"
                }
            }
        }
        return nil
    }
    
    
    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            print(message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    func getContacts() {
        
        self.requestForAccess { (accessGranted) in
            if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
                self.retrieveContactsWithStore(self.contactStore)
            }
        }
    }
    
    func retrieveContactsWithStore(_ store: CNContactStore) {
        do {
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                               CNContactImageDataKey as CNKeyDescriptor,
                               CNContactPhoneNumbersKey as CNKeyDescriptor] as [CNKeyDescriptor]
            
            let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
            
            
            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                self.contacts.append(contact)
            })
            
        } catch {
            print(error)
        }
    }
    
    init() {
        getContacts()
    }
}

extension String {
    func lastNCharacters(_ n: Int) -> String {
        if self.characters.count > n {
            return self.substring(from: self.index(self.endIndex, offsetBy: -n))
        } else {
            return self
        }
    }
}

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
    
    func getContacts() {
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
                if authorized {
                    self.retrieveContactsWithStore(store)
                }
                } as! (Bool, Error?) -> Void)
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.retrieveContactsWithStore(store)
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

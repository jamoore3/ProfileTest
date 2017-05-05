//
//  FireDatabase.swift
//  ProfileTest
//
//  Created by John Moore on 5/5/17.
//  Copyright © 2017 Passport. All rights reserved.
//

import Foundation
import Firebase


class FireDatabase {

    var refProfiles: FIRDatabaseReference!
    
    init() {
        refProfiles = FIRDatabase.database().reference().child("profiles")
    }
    
    func setProfileRecords() {
        for index in 0...profiles.count - 1 {
            let key = refProfiles.childByAutoId().key
            
            let record: [String:Any] = ["id": key,
                          "name": profiles[index].name,
                          "age": profiles[index].age,
                          "gender": profiles[index].gender,
                          "hobbies": profiles[index].hobbies,
                          "backgroundColor": profiles[index].backgroundColor,
                          "profileImage": profiles[index].profileImage]
            
            refProfiles.child(key).setValue(record)
        }
    }
    
    func getProfileRecords() {
        
        refProfiles.observe(FIRDataEventType.value, with: { (snapshot) in
            
            var newProfiles: [ProfileRecord] = []
            if snapshot.childrenCount > 0 {
                for records in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    let recordObject = records.value as? [String: AnyObject]
                    let id = recordObject?["id"]
                    let name = recordObject?["name"]
                    let age = recordObject?["age"]
                    let gender = recordObject?["gender"]
                    let hobbies = recordObject?["hobbies"]
                    let backgroundColor = recordObject?["backgroundColor"]
                    let profileImage = recordObject?["profileImage"]
                    
                    let record = ProfileRecord(id: id as! String, backgroundColor: backgroundColor as! Int, gender: gender as! Int, name: name as! String, age: age as! String, profileImage: profileImage as! Int, hobbies: hobbies as! String)
                    
                    newProfiles.append(record)
                }
            }
            
            profiles = newProfiles
            print("Profiles: " + String(describing: profiles))
        })
    }
}

var fireDatabase: FireDatabase = FireDatabase()

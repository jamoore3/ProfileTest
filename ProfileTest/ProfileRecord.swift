//
//  ProfileRecord.swift
//  ProfileTest
//
//  Created by John Moore on 5/3/17.
//  Copyright © 2017 Passport. All rights reserved.
//

import Foundation


// The main struct format for profile records
struct ProfileRecord {
    var id: String
    var backgroundColor: Int
    var gender: Int
    var name: String
    var age: String
    var profileImage: Int
    var hobbies: String
    
    init(id: String, backgroundColor: Int, gender: Int, name: String, age: String, profileImage: Int, hobbies: String ) {
        self.id = id
        self.backgroundColor = backgroundColor
        self.gender = gender
        self.name = name
        self.age = age
        self.profileImage = profileImage
        self.hobbies = hobbies
    }
}

/*  Global profile records.  'profiles' is the main collection, while 'sortedProfiles' is used for all of the sorting needs. */
var profiles: [ProfileRecord] = []
var sortedProfiles: [ProfileRecord] = []


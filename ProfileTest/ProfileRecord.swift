//
//  ProfileRecord.swift
//  ProfileTest
//
//  Created by John Moore on 5/3/17.
//  Copyright © 2017 Passport. All rights reserved.
//

import Foundation


struct ProfileRecord {
    var id: Int
    var backgroundColor: Int
    var gender: Int
    var name: String
    var age: String
    var profileImage: Int
    var hobbies: String
    
    init(id: Int, backgroundColor: Int, gender: Int, name: String, age: String, profileImage: Int, hobbies: String ) {
        self.id = id
        self.backgroundColor = backgroundColor
        self.gender = gender
        self.name = name
        self.age = age
        self.profileImage = profileImage
        self.hobbies = hobbies
    }
}

var record1 = ProfileRecord( id: 0, backgroundColor: 1, gender: 0, name: "John Anthony Moore", age: "42", profileImage: 0, hobbies: "DVDs" )
var record2 = ProfileRecord( id: 1, backgroundColor: 2, gender: 1, name: "Celia Lalene Moore", age: "55", profileImage: 1, hobbies: "Bible" )
var record3 = ProfileRecord( id: 2, backgroundColor: 3, gender: 0, name: "John Howard Moore", age: "64", profileImage: 2, hobbies: "News" )
var record4 = ProfileRecord( id: 3, backgroundColor: 4, gender: 0, name: "Michael David Moore", age: "24", profileImage: 3, hobbies: "iPhone" )


var profiles: [ProfileRecord] = [record1, record2, record3, record4]


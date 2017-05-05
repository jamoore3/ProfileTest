//
//  OverlayViewController.swift
//  ProfileTest
//
//  Created by John Moore on 5/4/17.
//  Copyright © 2017 Passport. All rights reserved.
//

import UIKit
import Firebase


class OverlayViewController: UIViewController {
    
    // Link to the main ViewController
    var parentController: ViewController? = nil
    
    // Persistent profile record
    var profileRecord = ProfileRecord( id: "", backgroundColor: 0, gender: 0, name: "", age: "", profileImage: 0, hobbies: "" )
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var hobbiesTextField: UITextField!
    
    @IBOutlet weak var puppy01Button: UIButton!
    @IBOutlet weak var puppy02Button: UIButton!
    @IBOutlet weak var puppy03Button: UIButton!
    
    @IBOutlet weak var kitten01Button: UIButton!
    @IBOutlet weak var kitten02Button: UIButton!
    @IBOutlet weak var kitten03Button: UIButton!
    
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Setup gesture recognizer in order to hide the text field keyboard when user taps outside of it
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Initialize elements of this view
        prepOverlayView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func prepOverlayView() {
        
        // Initialize the interface
        
        resetProfileRecord()
        
        resetTextFields()
        
        resetGenderSegment()
        
        resetProfileImages()
        
        // Set first image button alpha to make it appear selected by default
        puppy01Button.alpha = 0.5
    }
    
    // Call this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Hides the keyboard when 'return' button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func resetProfileRecord() {
        profileRecord.id = ""
        profileRecord.backgroundColor = 0
        profileRecord.gender = 0
        profileRecord.name = ""
        profileRecord.age = ""
        profileRecord.profileImage = 0
        profileRecord.hobbies = ""
    }
    
    func resetTextFields() {
        nameTextField.text = ""
        ageTextField.text = ""
        hobbiesTextField.text = ""
    }
    
    func resetGenderSegment() {
        genderSegment.selectedSegmentIndex = 0
    }
    
    func resetProfileImages() {
        puppy01Button.alpha = 1
        puppy02Button.alpha = 1
        puppy03Button.alpha = 1
        kitten01Button.alpha = 1
        kitten02Button.alpha = 1
        kitten03Button.alpha = 1
    }
    
    func addProfileRecordToProfiles() {
        
        // Handles all aspects of creating a new record
        profileRecord.id = ""
        
        if genderSegment.selectedSegmentIndex == 0 {
            profileRecord.gender = 0
            profileRecord.backgroundColor = 0
        } else {
            profileRecord.gender = 1
            profileRecord.backgroundColor = 1
        }
        
        profileRecord.name = nameTextField.text!
        profileRecord.age = ageTextField.text!
        profileRecord.hobbies = hobbiesTextField.text!
        
        // Adds the record to database and profile lists
        setProfileRecordToFirebase(profileRecord: &profileRecord)
        profiles.append(profileRecord)
        sortedProfiles.append(profileRecord)
        
    }
    
    func setProfileRecordToFirebase(profileRecord: inout ProfileRecord) {
        var refProfiles: FIRDatabaseReference!
        refProfiles = FIRDatabase.database().reference().child("profiles")
        
        let key = refProfiles.childByAutoId().key
        profileRecord.id = key
        
        let record: [String:Any] = ["id": key,
                                    "name": profileRecord.name,
                                    "age": profileRecord.age,
                                    "gender": profileRecord.gender,
                                    "hobbies": profileRecord.hobbies,
                                    "backgroundColor": profileRecord.backgroundColor,
                                    "profileImage": profileRecord.profileImage]
        
        refProfiles.child(key).setValue(record)
    }

    
    @IBAction func onProfileImagePressed(_ sender: Any) {
        
        resetProfileImages()
        
        // User selected one of the profile image buttons
        
        if sender as! UIButton === puppy01Button {
            puppy01Button.alpha = 0.5
            profileRecord.profileImage = 0
        }
        
        if sender as! UIButton === puppy02Button {
            puppy02Button.alpha = 0.5
            profileRecord.profileImage = 1
        }
        
        if sender as! UIButton === puppy03Button {
            puppy03Button.alpha = 0.5
            profileRecord.profileImage = 2
        }
        
        if sender as! UIButton === kitten01Button {
            kitten01Button.alpha = 0.5
            profileRecord.profileImage = 3
        }
        
        if sender as! UIButton === kitten02Button {
            kitten02Button.alpha = 0.5
            profileRecord.profileImage = 4
        }
        
        if sender as! UIButton === kitten03Button {
            kitten03Button.alpha = 0.5
            profileRecord.profileImage = 5
        }
    }
    
    @IBAction func onCreateProfileButtonPressed(_ sender: Any) {
        
        // Creates the new profile record, reloads the table and hides the overlay view
        
        addProfileRecordToProfiles()
        parentController?.tableView.reloadData()
        self.view.removeFromSuperview()
    }
}

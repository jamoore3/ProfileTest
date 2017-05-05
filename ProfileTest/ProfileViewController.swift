//
//  ProfileViewController.swift
//  ProfileTest
//
//  Created by John Moore on 5/4/17.
//  Copyright © 2017 Passport. All rights reserved.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController {
    
    // References to navigation controller, table view controller and index of the selected profile record
    var navController: UINavigationController? = nil
    var tableViewController: ViewController? = nil
    var profileIndex: Int = 0
    
    var profileRecord = ProfileRecord( id: "", backgroundColor: 0, gender: 0, name: "", age: "", profileImage: 0, hobbies: "" )
    
    @IBOutlet weak var bgDefaultButton: UIButton!
    @IBOutlet weak var bgWhiteButton: UIButton!
    @IBOutlet weak var bgYellowButton: UIButton!
    @IBOutlet weak var bgRedButton: UIButton!
    
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var genderAndAgeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Adds a gesture recognizer used to hide the text field keyboard when user taps outside of it
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Initialize the view settings
        prepProfileView()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        // Reloads the table view when navigating back to the main view controller
        if (self.isMovingFromParentViewController){
            tableViewController?.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepProfileView() {
        
        prepProfileRecord()
        
        //Profile image
        var photo: UIImage
        switch profileRecord.profileImage {
        case 0:
            photo = UIImage(named: "puppy01")!
        case 1:
            photo = UIImage(named: "puppy02")!
        case 2:
            photo = UIImage(named: "puppy03")!
        case 3:
            photo = UIImage(named: "kitten01")!
        case 4:
            photo = UIImage(named: "kitten02")!
        case 5:
            photo = UIImage(named: "kitten03")!
        default:
            photo = UIImage(named: "puppy01")!
        }
        profileImage.image = photo
        
        // Name
        nameLabel.text = profileRecord.name
        
        // Gender and age
        var genderAgeText: String
        if profileRecord.gender == 0 {
            genderAgeText = "Male     "
        } else {
            genderAgeText = "Female   "
        }
        genderAgeText += "Age:  \(profileRecord.age)"
        
        genderAndAgeLabel.text = genderAgeText
        
        // Hobbies
        hobbiesTextField.text = profileRecord.hobbies
    }
    
    func prepProfileRecord() {
        
        // Initialize profile record using the global profile list
        
        profileRecord.id = sortedProfiles[profileIndex].id
        profileRecord.backgroundColor = sortedProfiles[profileIndex].backgroundColor
        profileRecord.gender = sortedProfiles[profileIndex].gender
        profileRecord.name = sortedProfiles[profileIndex].name
        profileRecord.age = sortedProfiles[profileIndex].age
        profileRecord.profileImage = sortedProfiles[profileIndex].profileImage
        profileRecord.hobbies = sortedProfiles[profileIndex].hobbies
    }
    
    func updateProfileRecordInProfiles() {
        
        // Updates the profile record in the database and sorted profiles list
        
        sortedProfiles[profileIndex].backgroundColor = profileRecord.backgroundColor
        sortedProfiles[profileIndex].hobbies = hobbiesTextField.text!
        
        var refProfiles: FIRDatabaseReference!
        refProfiles = FIRDatabase.database().reference().child("profiles")
        
        let record: [String:Any] = ["id": profileRecord.id,
                                    "name": profileRecord.name,
                                    "age": profileRecord.age,
                                    "gender": profileRecord.gender,
                                    "hobbies": hobbiesTextField.text!,
                                    "backgroundColor": profileRecord.backgroundColor,
                                    "profileImage": profileRecord.profileImage]
        
        refProfiles.child(profileRecord.id).setValue(record)
    }
    
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Executed when the user taps the return button on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func onBackgroundColorButtonPressed(_ sender: Any) {
        
        // Handles the logic of selecting a new background color, or reseting to default gender background colors
        
        if sender as! UIButton === bgDefaultButton {
            if profileRecord.gender == 0 {
                profileRecord.backgroundColor = 0
            } else {
                profileRecord.backgroundColor = 1
            }
        }
        
        if sender as! UIButton === bgRedButton {
            profileRecord.backgroundColor = 2
        }
        
        if sender as! UIButton === bgYellowButton {
            profileRecord.backgroundColor = 3
        }
        
        if sender as! UIButton === bgWhiteButton {
            profileRecord.backgroundColor = 4
        }
    }
    
    @IBAction func onDeleteProfileButtonPressed(_ sender: Any) {
        
        // Deletes profile from database and profile lists
        let confirmAlert = UIAlertController(title: "Are you sure?", message: "The profile record will be lost.", preferredStyle: UIAlertControllerStyle.alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            let id: String = sortedProfiles[self.profileIndex].id
            
            //Delete from firebase
            FIRDatabase.database().reference().child("profiles").child(id).removeValue { (error, ref) in
                if error != nil {
                    print("error \(error)")
                }
            }
            
            sortedProfiles.remove(at: self.profileIndex)
            for index in 0...profiles.count - 1 {
                if profiles[index].id == id {
                    profiles.remove(at: index)
                    break
                }
            }
            
            // Reloads the table and navigates back to the main ViewController
            self.tableViewController?.tableView.reloadData()
            self.navController!.popViewController(animated: true)
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(confirmAlert, animated: true, completion: nil)
    }
    
    @IBAction func onDoneButtonPressed(_ sender: Any) {
        
        // Updates database and profile lists with any changes to the profile, then returns to the main ViewController
        updateProfileRecordInProfiles()
        tableViewController?.tableView.reloadData()
        navController!.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

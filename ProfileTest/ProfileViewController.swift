//
//  ProfileViewController.swift
//  ProfileTest
//
//  Created by John Moore on 5/4/17.
//  Copyright © 2017 Passport. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var navController: UINavigationController? = nil
    var tableViewController: ViewController? = nil
    var profileIndex: Int = 0
    var profileRecord = ProfileRecord( id: 0, backgroundColor: 0, gender: 0, name: "", age: "", profileImage: 0, hobbies: "" )
    
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
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepProfileView()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
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
        
        
        nameLabel.text = profileRecord.name
        
        var genderAgeText: String
        if profileRecord.gender == 0 {
            genderAgeText = "Male     "
        } else {
            genderAgeText = "Female   "
        }
        genderAgeText += "Age:  \(profileRecord.age)"
        
        genderAndAgeLabel.text = genderAgeText
        
        hobbiesTextField.text = profileRecord.hobbies
    }
    
    func prepProfileRecord() {
        profileRecord.id = sortedProfiles[profileIndex].id
        profileRecord.backgroundColor = sortedProfiles[profileIndex].backgroundColor
        profileRecord.gender = sortedProfiles[profileIndex].gender
        profileRecord.name = sortedProfiles[profileIndex].name
        profileRecord.age = sortedProfiles[profileIndex].age
        profileRecord.profileImage = sortedProfiles[profileIndex].profileImage
        profileRecord.hobbies = sortedProfiles[profileIndex].hobbies
    }
    
    func updateProfileRecordInProfiles() {
        sortedProfiles[profileIndex].backgroundColor = profileRecord.backgroundColor
        sortedProfiles[profileIndex].hobbies = hobbiesTextField.text!
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func onBackgroundColorButtonPressed(_ sender: Any) {
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
        
        let confirmAlert = UIAlertController(title: "Are you sure?", message: "The profile record will be lost.", preferredStyle: UIAlertControllerStyle.alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            let id: Int = sortedProfiles[self.profileIndex].id
            sortedProfiles.remove(at: self.profileIndex)
            for index in 0...profiles.count - 1 {
                if profiles[index].id == id {
                    profiles.remove(at: index)
                    break
                }
            }
            
            self.tableViewController?.tableView.reloadData()
            self.navController!.popViewController(animated: true)
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(confirmAlert, animated: true, completion: nil)
    }
    
    @IBAction func onDoneButtonPressed(_ sender: Any) {
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

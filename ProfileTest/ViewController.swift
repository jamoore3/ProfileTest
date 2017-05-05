//
//  ViewController.swift
//  ProfileTest
//
//  Created by John Moore on 5/3/17.
//  Copyright © 2017 Passport. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cellReuseIdentifier = "CustomTableViewCell"
    
    //Mark: Properties
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // View controller references, needed in order to pass some info to them
    var overlayViewController: OverlayViewController! = nil
    var profileViewController: ProfileViewController! = nil

    // A third profile list needed to handle filters
    var tempProfiles: [ProfileRecord] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setting view controller references
        
        let ovStoryBoard: UIStoryboard = UIStoryboard.init( name: "OverlayView", bundle: nil )
        overlayViewController = ovStoryBoard.instantiateInitialViewController() as! OverlayViewController!
    
        // Lowering alpha on the overlay view background
        overlayViewController.view.backgroundColor = UIColor.clear.withAlphaComponent(0.7)
        overlayViewController.parentController = self
        
        let pvStoryBoard: UIStoryboard = UIStoryboard.init( name: "ProfileView", bundle: nil )
        profileViewController = pvStoryBoard.instantiateInitialViewController() as! ProfileViewController!
        
        // Grab current records from the database
        getProfileRecordsFromFirebase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProfileRecordsFromFirebase() {
        
        var refProfiles: FIRDatabaseReference!
        refProfiles = FIRDatabase.database().reference().child("profiles")
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
            
            self.handleLoadFromFirebase(profileRecords: newProfiles)
        })
    }
    
    func handleLoadFromFirebase(profileRecords: [ProfileRecord]) {
        
        // Initialize all profile record collections, then reload the tableView
        if profileRecords.count > 0 {
            profiles = profileRecords
            sortedProfiles = profiles
            tempProfiles = sortedProfiles
            self.tableView.reloadData()
        }
    }
    
    
    //Mark: Actions
    @IBAction func onClearSortingPressed(_ sender: Any) {
        // Return to default list format without sorting
        sortedProfiles.removeAll()
        sortedProfiles = profiles
        tableView.reloadData()
    }
    
    // Various functions to handle all sorting requirements
    @IBAction func onAgeDescendPressed(_ sender: Any) {
        let temp = sortedProfiles.sorted(by: { Int($0.age)! > Int($1.age)! })
        sortedProfiles = temp
        tableView.reloadData()
    }
    
    @IBAction func onAgeAscendPressed(_ sender: Any) {
        let temp = sortedProfiles.sorted(by: { Int($0.age)! < Int($1.age)! })
        sortedProfiles = temp
        tableView.reloadData()
    }
    
    @IBAction func onNameDescendPressed(_ sender: Any) {
        let temp = sortedProfiles.sorted(by: { $0.name > $1.name })
        sortedProfiles = temp
        tableView.reloadData()
    }
    
    @IBAction func onNameAscendPressed(_ sender: Any) {
        let temp = sortedProfiles.sorted(by: { $0.name < $1.name })
        sortedProfiles = temp
        tableView.reloadData()
    }
    
    @IBAction func onGenderSegmentChanged(_ sender: Any) {
        // Just reload the table, male/female filtering is handled in the table functions below
        tableView.reloadData()
    }
    
    @IBAction func onAddProfileButtonPressed(_ sender: Any) {
        // Show the 'create profile' overlay view
        view.addSubview( overlayViewController.view )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sortedProfiles.count == 0 {
            return 0
        }
        
        var count: Int = 0
        tempProfiles.removeAll()
        
        // Filter by gender selection: male/female/all
        for index in 0...sortedProfiles.count - 1 {
            if (genderSegment.selectedSegmentIndex == 0 && sortedProfiles[index].gender == 0) {
                count += 1
                tempProfiles.append(sortedProfiles[index])
            }
            if (genderSegment.selectedSegmentIndex == 1 && sortedProfiles[index].gender == 1) {
                count += 1
                tempProfiles.append(sortedProfiles[index])
            }
            if (genderSegment.selectedSegmentIndex == 2) {
                count += 1
                tempProfiles.append(sortedProfiles[index])
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Setup custom table cell and fill it with profile data
        
        guard let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? CustomTableViewCell else {
            fatalError("The dequeued cell is not an instance of CustomTableViewCell.")
        }
        
        // Name
        cell.nameLabel.text = tempProfiles[indexPath.row].name
        
        // Gender and age
        var genderAndAgeLabel: String
        if tempProfiles[indexPath.row].gender == 0 {
            genderAndAgeLabel = "Male"
        } else {
            genderAndAgeLabel = "Female"
        }
        genderAndAgeLabel += "     Age:  \(tempProfiles[indexPath.row].age)"
        cell.genderAndAgeLabel.text = genderAndAgeLabel
        
        // Background color
        switch tempProfiles[indexPath.row].backgroundColor {
        case 0:
            cell.backgroundColor = UIColor.blue
        case 1:
            cell.backgroundColor = UIColor.green
        case 2:
            cell.backgroundColor = UIColor.red
        case 3:
            cell.backgroundColor = UIColor.yellow
        case 4:
            cell.backgroundColor = UIColor.white
        default:
            cell.backgroundColor = UIColor.white
        }
        
        // Hobbies
        cell.hobbiesLabel.text = "Hobbies: \(tempProfiles[indexPath.row].hobbies)"
        
        
        // Profile image
        var photo: UIImage
        switch tempProfiles[indexPath.row].profileImage {
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
        cell.profileImage.image = photo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set some initial values in the profileViewController, then push it into view
        
        profileViewController.navController = navigationController
        profileViewController.tableViewController = self
        profileViewController.profileIndex = indexPath.row
        
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}


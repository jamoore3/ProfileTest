//
//  ViewController.swift
//  ProfileTest
//
//  Created by John Moore on 5/3/17.
//  Copyright © 2017 Passport. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cellReuseIdentifier = "CustomTableViewCell"
    
    //Mark: Properties
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var childViewController: OverlayViewController! = nil
    var profileViewController: ProfileViewController! = nil
    
    var tempProfiles: [ProfileRecord] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let ovStoryBoard: UIStoryboard = UIStoryboard.init( name: "OverlayView", bundle: nil )
        childViewController = ovStoryBoard.instantiateInitialViewController() as! OverlayViewController!
        childViewController.view.backgroundColor = UIColor.clear.withAlphaComponent(0.7)
        childViewController.parentController = self
        
        let pvStoryBoard: UIStoryboard = UIStoryboard.init( name: "ProfileView", bundle: nil )
        profileViewController = pvStoryBoard.instantiateInitialViewController() as! ProfileViewController!
        
        sortedProfiles = profiles
        tempProfiles = sortedProfiles
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Mark: Actions
    @IBAction func onClearSortingPressed(_ sender: Any) {
        sortedProfiles.removeAll()
        sortedProfiles = profiles
        tableView.reloadData()
    }
    
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
        tableView.reloadData()
    }
    
    @IBAction func onAddProfileButtonPressed(_ sender: Any) {
        view.addSubview( childViewController.view )
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        tempProfiles.removeAll()
        
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
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? CustomTableViewCell else {
            fatalError("The dequeued cell is not an instance of CustomTableViewCell.")
        }
        
        cell.nameLabel.text = tempProfiles[indexPath.row].name
        cell.hobbiesLabel.text = tempProfiles[indexPath.row].hobbies
        
        var genderAndAgeLabel: String
        
        if tempProfiles[indexPath.row].gender == 0 {
            genderAndAgeLabel = "Male"
        } else {
            genderAndAgeLabel = "Female"
        }
        genderAndAgeLabel += "     Age:  \(tempProfiles[indexPath.row].age)"
        cell.genderAndAgeLabel.text = genderAndAgeLabel
        
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
        
        cell.hobbiesLabel.text = "Hobbies: \(tempProfiles[indexPath.row].hobbies)"
        
        
        //Profile image
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
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        profileViewController.navController = navigationController
        profileViewController.tableViewController = self
        profileViewController.profileIndex = indexPath.row
        
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}


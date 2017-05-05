//
//  ProfileViewController.swift
//  ProfileTest
//
//  Created by John Moore on 5/4/17.
//  Copyright © 2017 Passport. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var bgWhiteButton: UIButton!
    @IBOutlet weak var bgYellowButton: UIButton!
    @IBOutlet weak var bgRedButton: UIButton!
    @IBOutlet weak var bgGreenButton: UIButton!
    @IBOutlet weak var bgBlueButton: UIButton!
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var genderAndAgeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    var parentController: UINavigationController? = nil
    var profileIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func onDeleteProfileButtonPressed(_ sender: Any) {
    }
    
    @IBAction func onDoneButtonPressed(_ sender: Any) {
        parentController!.popViewController(animated: true)
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

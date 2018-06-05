//
//  LoginViewController.swift
//  InstaClone
//
//  Created by Christian Liefeldt on 05.06.18.
//  Copyright © 2018 CL. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtBenutzer: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var activeUser = String()
    var aktivierteNutzer = [String]()
    var ready = Bool()
    var activePassword = String()
    var whichSegment = Int()
    
    @IBAction func SegmentControll(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            btnSave.setTitle("Login", for: .normal)
            lblPassword.text = "Password:"
            lblName.text = "Ghost name:"
            txtBenutzer.placeholder = ""
            whichSegment = 1
        case 1:
            btnSave.setTitle("Save!", for: .normal)
            lblPassword.text = "What's your password?"
            lblName.text = "What's your Ghost name?"
            txtBenutzer.placeholder = "Karl"
            whichSegment = 2
        default: print("Segment Error")
        }
    }
    
    func myMethod() {
        if whichSegment == 1 {
            performSegue(withIdentifier: "MapView", sender: nil)
        } else {
            var user = PFUser()
            user.username = activeUser
            user.password = activePassword
            //user.email = "email@example.com"
            //user["phone"] = "415-392-0202"
            user.signUpInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print(success)
                } else {
                    print(error)
                }
            }
        }
    }
    
    
    @IBAction func btnSave(_ sender: Any) {
        if txtBenutzer.text == "" || txtPassword.text == "" {
            let alert = UIAlertController(title: "Information", message: "Bitte alles Felder ausfüllen!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            if (txtPassword.text?.count)! < 5 {
                let alert = UIAlertController(title: "Password", message: "Das Passwort ist zu kurz. Bitte min. 6 Zeichen verwenden", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                ready = true
                activeUser = txtBenutzer.text!
                activePassword = txtPassword.text!
                //txtBenutzer.isUserInteractionEnabled = false
                //txtPassword.isUserInteractionEnabled = false
                myMethod()
            }
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

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
        let user = PFUser()
        user.username = activeUser
        user.password = activePassword
        
        if whichSegment == 1 { //login, es wird nichts gespeichert.
            PFUser.logInWithUsername(inBackground: user.username!, password: user.password!) { (user, error: Error?) in
                
                if ((user) != nil) {
                    print("Login success")
                    self.ready = true
                    UserDefaults.standard.set(self.ready, forKey: "ready") //Daten speichern
                    UserDefaults.standard.set(self.activeUser, forKey: "User")
                    self.activePassword = ""
                    self.activeUser = ""
                    self.txtPassword.text = ""
                    self.txtBenutzer.text = ""
                   self.performSegue(withIdentifier: "MapView", sender: nil)
                } else {
                    print(error)
                    let alert = UIAlertController(title: "LogIn Error", message: "LogIn fehlgeschlagen", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            
        } else { //SignUp, Benutzer wird erstellt und gespeichert
            //performSegue(withIdentifier: "MapView", sender: nil)
            
            //user.email = "email@example.com"
            //user["phone"] = "415-392-0202"
            user.signUpInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print(success)
                    self.activePassword = ""
                    self.activeUser = ""
                    self.txtPassword.text = ""
                    self.txtBenutzer.text = ""
                } else {
                    print(error)
                    let alert = UIAlertController(title: "Benutzername", message: "Benutzername schon vergeben!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
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
           activeUser = txtBenutzer.text!
            if activeUser.contains(" ") {
                let alert = UIAlertController(title: "Information", message: "Leerzeichen sind nicht erlaubt", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("beinhaltet leerschritt")
            } else {
                if (txtPassword.text?.count)! < 5 {
                    let alert = UIAlertController(title: "Password", message: "Das Passwort ist zu kurz. Bitte min. 6 Zeichen verwenden", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    
                    activeUser = txtBenutzer.text!
                    activePassword = txtPassword.text!
                    //txtBenutzer.isUserInteractionEnabled = false
                    //txtPassword.isUserInteractionEnabled = false
                    myMethod()
            }
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

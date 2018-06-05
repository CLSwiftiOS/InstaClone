//
//  ViewControllerSetup.swift
//  InstaClone
//
//  Created by Christian Liefeldt on 30.05.18.
//  Copyright © 2018 CL. All rights reserved.
//

import UIKit

class ViewControllerSetup: UIViewController {
    
    func testfunc(){
        print("test123")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { //Bildschirm dreht sich nicht mit
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool { //Bildschirm dreht sich nicht mit
        return false
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        testfunc()
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

}

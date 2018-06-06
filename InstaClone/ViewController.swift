//
//  ViewController.swift
//  InstaClone
//
//  Created by Christian Liefeldt on 17.04.18.
//  Copyright © 2018 CL. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CLLocationManagerDelegate, CBCentralManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var lblEins: UILabel!
    @IBOutlet weak var lblZwei: UILabel!
    @IBOutlet weak var lblDrei: UILabel!
    
    @IBOutlet weak var viewBüro2: UIView!
    @IBOutlet weak var viewBüro1: UIView!
    let locationManager = CLLocationManager()
    let SetupView = ViewControllerSetup()
    var bManager = CBCentralManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, identifier: "WEB-EDV")
    var vLocation = String()
    var activeBeaconMinior = Int()
    var gefundeneBeacon = [Int]()
    var aktivierteNutzer = [String]()
    var activeUser = String()
    var pointPath = UIBezierPath()
    let trackLayerBeacon = CAShapeLayer()
    var letzterOrt = String()
    var ready = Bool()
    var room = Int()
    var center = CGPoint()
  
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        SetupView.testfunc()
        startSetup()
    }
    
    func startSetup() {
        let NummernObject = UserDefaults.standard.object(forKey: "ready") //Daten laden
        if let sReady = NummernObject as! Bool? {
            ready = sReady
        }
        let UserObject = UserDefaults.standard.object(forKey: "User") //Daten laden
        if let sUser = UserObject as! String? {
            activeUser = sUser
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        bManager.delegate = self
        locationManager.startRangingBeacons(in: region)
       
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveLocation() {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let date = Date()
        let BenutzerOrte = PFObject(className:"BenutzerOrte")
        BenutzerOrte["Ort"] = vLocation
        BenutzerOrte["minior"] = activeBeaconMinior
        BenutzerOrte["Time"] = formatter.string(from: date)
        BenutzerOrte["Benutzer"] = activeUser
        BenutzerOrte.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                print("Speichervorgang war erfolgreich")
            } else {
                print(error)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if ready == false {
            
        } else {
            let knowBeacons = beacons.filter{ $0.proximity == CLProximity.immediate || $0.proximity == CLProximity.near}
            if knowBeacons.count > 0 {
                let nearestBeacon = knowBeacons.first!
                activeBeaconMinior = Int(nearestBeacon.minor)
                switch nearestBeacon.minor {
                case 22438: vLocation = "Büro oben 1"
                    center = viewBüro1.center
                case 3290: vLocation = "Büro oben 2"
                    center = viewBüro2.center
                case 22936: vLocation = "Küche oben"
                    center = viewBüro2.center
                case 35885: vLocation = "Bad oben"
                    center = viewBüro2.center
                case 17221: vLocation = "Küche unten"
                    center = viewBüro2.center
                case 37769: vLocation = "Creativ Room"
                    center = viewBüro2.center
                case 28501: vLocation = "offenes Büro"
                    center = viewBüro2.center
                default: vLocation = "Flur"
                    
                }
                
                if nearestBeacon.accuracy < 1.0 {
                    lblEins.text = vLocation
                    lblZwei.text = "\(nearestBeacon.accuracy)"
                    if vLocation == letzterOrt {
                    } else {
                        if activeUser == "" {
                        } else {
                            letzterOrt = vLocation
                            saveLocation()
                            setTrackPoint()
                        }
                    }
                } else {
                    vLocation = "Flur"
                    lblEins.text = vLocation
                    
                }
            }
            
        }
    }
    
    func setTrackPoint() {
        var vPostion = trackLayerBeacon.position
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.duration = 1.5
        moveAnimation.fromValue = vPostion
        moveAnimation.toValue = center
        pointPath = UIBezierPath(arcCenter: .zero, radius: 15, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayerBeacon.path = pointPath.cgPath
        trackLayerBeacon.strokeColor = UIColor.darkGray.cgColor
        trackLayerBeacon.fillColor = UIColor.black.cgColor
        trackLayerBeacon.lineWidth = 10
        trackLayerBeacon.lineCap = kCALineCapRound
        trackLayerBeacon.position = center
        view.layer.addSublayer(trackLayerBeacon)
        trackLayerBeacon.add(moveAnimation, forKey: "move")
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if ready == true {
        if central.state == .poweredOff {
            let alert = UIAlertController(title: "Bluetooth Alarm", message: "Bitte Bluetooth einschalten!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    }
    
   
    
    
}





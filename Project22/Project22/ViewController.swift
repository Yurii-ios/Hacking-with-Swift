//
//  ViewController.swift
//  Project22
//
//  Created by Yurii Sameliuk on 07/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    ///  add in Plist:  Privacy - Location Always and When In Use Usage Description
    ///           Privacy - Location When In Use Usage Description
    
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var secondDistanceReading: UILabel!
    
    //let first = false
var count = 0
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        //locationManager?.requestWhenInUseAuthorization() // rabotaet s  - Privacy - Location When In Use Usage Description
        
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        guard let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5") else {return}
        guard let uuid1 = UUID(uuidString: "E2C56DB5-DFFB-48D2-D0F5A71096E0") else {return}
        secondDistanceReading .text = "\(uuid1.uuidString)"
        secondDistanceReading.text = "\(uuid.uuidString)"
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        let beaconRegion1 = CLBeaconRegion(uuid: uuid1, major: 234, minor: 678, identifier: "SecondBeacon")
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startMonitoring(for: beaconRegion1)
        locationManager?.showsBackgroundLocationIndicator = true
        locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        locationManager?.startRangingBeacons(satisfying: beaconRegion1.beaconIdentityConstraint)
        
        
        if count < 1 {
        let ac = UIAlertController(title: "Resault", message: "First Beacon", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(ac, animated: true, completion: nil)
        }
        count += 1
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "far"
                //self.secondDistanceReading.text = "second far"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "near"
                //self.secondDistanceReading.text = "second near"
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "immediate"
                //self.secondDistanceReading.text = "second immediate"
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "Uncnown"
               // self.secondDistanceReading.text = "second Uncnown"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: CLProximity.unknown)
        }
    }
}


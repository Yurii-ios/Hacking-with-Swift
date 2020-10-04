//
//  ViewController.swift
//  Project16
//
//  Created by Yurii Sameliuk on 23/05/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "MapView Type", style: UIBarButtonItem.Style.plain, target: self, action: #selector(actionMapType))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olimpics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the city of Light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country insede ")
        let washington = Capital(title: "Washington", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "named after George himself")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
       
    }
    
    @objc func actionMapType() {
        let ac = UIAlertController(title: "Chose map view", message: "satelite", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "Hybrid", style: UIAlertAction.Style.default, handler: showMap))
        ac.addAction(UIAlertAction(title: "HybridFlyover", style: UIAlertAction.Style.default, handler: showMap))
        ac.addAction(UIAlertAction(title: "MutedStandard", style: UIAlertAction.Style.default, handler: showMap))
        ac.addAction(UIAlertAction(title: "Satellite", style: UIAlertAction.Style.default, handler: showMap))
        ac.addAction(UIAlertAction(title: "SatelliteFlyover", style: UIAlertAction.Style.default, handler: showMap))
        ac.addAction(UIAlertAction(title: "Standard", style: UIAlertAction.Style.default, handler: showMap))
        present(ac, animated: true, completion: nil)
    }
    
    func showMap(action: UIAlertAction) {
        title = action.title
        switch action.title {
        case "Hybrid":
            mapView.mapType = .hybrid
        case "HybridFlyover":
             mapView.mapType = .hybridFlyover
        case "MutedStandard":
            mapView.mapType = .mutedStandard
        case "Satellite":
            mapView.mapType = .satellite
        case "SatelliteFlyover":
             mapView.mapType = .satelliteFlyover
        case "Standard":
                mapView.mapType = .standard
        default:
            return
        }
   
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else {return nil}
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            //cwet bylawki
            annotationView?.pinTintColor = .green
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .infoDark)
            annotationView?.rightCalloutAccessoryView = btn
            
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let capital = view.annotation as? Capital else {return}
    
        let placeName = capital.title
       // let placeInfo = capital.info
        if let vc = storyboard?.instantiateViewController(withIdentifier:
            "DetailWebView") as? DetailWebViewViewController {
            vc.websites = placeName ?? "Wroclaw"
            navigationController?.pushViewController(vc, animated: true)
        }
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: UIAlertController.Style.alert)
//        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//        present(ac, animated: true, completion: nil)
        
        
        
    }
}


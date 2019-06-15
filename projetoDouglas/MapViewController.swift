//
//  MapViewController.swift
//  ParqueFarroupilha
//
//  Created by IOS SENAC on 11/05/2019.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func didtapEnableLocation(_ sender: Any) {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .authorizedAlways ||
            authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }else{
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    
    
    var locationManager = CLLocationManager()
    var ultimaLocalizacao: CLLocation?
    var onibus: [Onibus]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        mapView.delegate = self
        
        
        
    }
    
    
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse ||
            status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latest = locations.first{
            
            if ultimaLocalizacao == nil {
                ultimaLocalizacao = latest
            }else{
                let distance = ultimaLocalizacao?.distance(from: latest) ?? 0
                let metros = Measurement(value: distance, unit: UnitLength.meters)
                print("Distancia em metros: \(metros)")
                
                let kilometros = metros.converted(to: .kilometers)
                print("Distancia em kilometros: \(kilometros)")
            }
            ultimaLocalizacao = latest
            
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        
      
        return annotationView
    }
    
}








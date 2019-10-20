//
//  ViewController.swift
//  NasaApp
//
//  Created by Maykon Meneghel on 19/10/19.
//  Copyright © 2019 Maykon Meneghel. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet var profileView: UIView!
    @IBOutlet var cardButton: UIView!
    @IBOutlet var sosButton: UIButton!
    @IBOutlet var reportButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    
    var selectedPin:MKPlacemark? = nil
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.layer.cornerRadius = profileView.frame.width/2
        cardButton.layer.cornerRadius = 20.0
        sosButton.layer.cornerRadius = 15.0
        reportButton.layer.cornerRadius = 15.0
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        let db = Firestore.firestore()
        db.collection("Data").addSnapshotListener { (data, _) in
            if let _ = data { ModelMap.loadMap(completion: { _ in
                    for location in ModelMap.shared.dataList{
                        let placemark =  MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:Double(location.latitude)!, longitude: Double(location.longitude)!))
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = placemark.coordinate
                        annotation.title = placemark.name
                        if let city = placemark.locality,
                            let state = placemark.administrativeArea {
                            annotation.subtitle = "\(city) \(state)"
                        }
                        self.mapView.addAnnotation(annotation)
                        let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
                        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
                        self.mapView.setRegion(region, animated: true)
                        let nota = MKPointAnnotation()
                        nota.title = location.frp
                        nota.coordinate = CLLocationCoordinate2D(latitude:Double(location.latitude)!, longitude: Double(location.longitude)!)
                        self.mapView.addAnnotation(nota)
                    }
                self.mapView.reloadInputViews()
                })
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else {
            return nil
        }
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "icon01")
        }
        return annotationView
    }

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//       guard annotation is MKPointAnnotation else { return nil }
//
//       let annotationIdentifier = "AnnotationIdentifier"
//       var annotationView: MKAnnotationView?
//       if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
//           annotationView = dequeuedAnnotationView
//           annotationView?.annotation = annotation
//       }
//       else {
//           annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
//           annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//       }
//        if let annotationView = annotationView {
//        // Configure your annotation view here
//            annotationView.canShowCallout = true
//            annotationView.image = UIImage(named: "icon01")
//        }
//       return annotationView
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

}


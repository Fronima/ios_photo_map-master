//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , LocationsViewControllerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var camera: UIButton!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                              MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
        mapView.delegate = self
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePic(_ sender: Any) {
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        imagepicker.sourceType = .camera
        self.present(imagepicker, animated: true)
    }
    
    func locationsPicked(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let annotation = MKPointAnnotation()
        annotation.title = "Photo"
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        controller.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true){
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuse = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuse)
        if let annotationView = annotationView {
            let imageView = annotationView.leftCalloutAccessoryView as! UIImageView
            imageView.image = image ?? #imageLiteral(resourceName: "camera")
            
        }
        else{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuse)
            annotationView?.canShowCallout = true
            annotationView?.leftCalloutAccessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
            imageView.image = image ?? #imageLiteral(resourceName: "camera")
        }
        return annotationView
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "tagSegue" {
            if let vc = segue.destination as? LocationsViewController {
                vc.delegate = self
            }
        }
    }
    

}

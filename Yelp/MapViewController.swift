//
//  MapViewController.swift
//  Yelp
//
//  Created by tingting_gao on 10/30/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var foodMap: MKMapView!

    var mapBusinesses: [Business]!

    override func viewDidLoad() {
        super.viewDidLoad()
        foodMap.addAnnotations(mapBusinesses)
        if mapBusinesses != nil {
            let business = mapBusinesses[0]
            let initialLocation = business.coordinate
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation, 3000, 3000)
            foodMap.setRegion(coordinateRegion, animated: true)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
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

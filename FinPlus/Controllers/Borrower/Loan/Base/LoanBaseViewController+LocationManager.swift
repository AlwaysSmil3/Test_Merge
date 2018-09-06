//
//  LoanBaseViewController+LocationManager.swift
//  FinPlus
//
//  Created by Cao Van Hai on 9/6/18.
//  Copyright © 2018 Cao Van Hai. All rights reserved.
//

import Foundation
import CoreLocation

extension LoanBaseViewController {
    
    func initLocationManager() {
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
        }
        
        // Ask for Authorisation from the User.
        self.locationManager?.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
        
    }
    

}

//MARK: CLLocationManagerDelegate
extension LoanBaseViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        DataManager.shared.currentLocation = locValue
    }
}


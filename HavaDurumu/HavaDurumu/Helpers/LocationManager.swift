//
//  LocationManager.swift
//  HavaDurumu
//
//  Created by Yunus Emre ÖZŞAHİN on 31.03.2024.
//
//
/*
import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestLocation() {
        // Kullanıcıya konum izni iste
        self.locationManager.requestWhenInUseAuthorization()
        
        // Konum güncellemelerini başlat
        self.locationManager.startUpdatingLocation()
    }
    
    // CLLocationManagerDelegate metodları
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Konum güncellendiğinde burası çağrılır
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            
            // Konum güncellemelerini durdur
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Konum alınamadığında burası çağrılır
        print("Konum alınamadı: \(error.localizedDescription)")
    }
}


*/

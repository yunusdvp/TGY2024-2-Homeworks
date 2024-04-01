//
//  ViewController.swift
//  HavaDurumu
//
//  Created by Yunus Emre ÖZŞAHİN on 30.03.2024.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var degreeLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    //@IBOutlet weak var weatherCollectionView: UICollectionView!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    @IBOutlet weak var popLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //fetchWeatherData(latitude: 36.68, longitude: 33.83, apiKey: "4c2aa4b5ab67ec27c9597734c38ef6d9")
        
        //let locationManager = LocationManager()
        //locationManager.requestLocation()
        
        requestLocationAuthorization()
        

        
        
    }
    


}
extension ViewController: CLLocationManagerDelegate {
    
    private static var locationManager: CLLocationManager = CLLocationManager()

    public func requestLocationAuthorization() {
        ViewController.locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            ViewController.locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("Konum izni reddedildi veya sınırlı.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Konum izni zaten verildi.")
        @unknown default:
            break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            ViewController.locationManager.startUpdatingLocation()
        }
    }
    private func updateUI(with data: [String: Any]) {
        if let temperature = data["temperature"] as? Double {
            degreeLabel.text = "\(Int(temperature-273.15))°C"
            print(temperature)
        }
        if let humidity = data["humidity"] as? Int {
            humidityLabel.text = "Nem Oranı: \(humidity)%"
            print(humidity)
        }
        if let name = data["name"] as? String {
            cityNameLabel.text = name
            print(name)
            
        }
        if let icon = data["icon"] as? String{
            weatherImageView.image = UIImage(named: icon)
            print(icon)
        }
        if let description = data["description"] as? String{
            popLabel.text = description
            print(description)
        }
        
        // Hava durumu resmini güncellemek için uygun sistem simgesini kullanabilirsiniz.
        // Örneğin, bulutlu bir hava için:
        //weatherImageView.image = UIImage(systemName: "cloud.fill")
    }
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            fetchCurrentData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, apiKey: "4c2aa4b5ab67ec27c9597734c38ef6d9") { (weatherData, error) in
                if let error = error {
                    print("Hava durumu verileri alınamadı: \(error.localizedDescription)")
                    return
                }
                
                if let weatherData = weatherData {
                    // Hava durumu verilerini aldık, burada yapmak istediğiniz işlemleri yapabilirsiniz.
                    // Örneğin, updateUI fonksiyonunu çağırabilirsiniz.
                    DispatchQueue.main.async {
                        self.updateUI(with: weatherData)
                    }
                    
                }
            }
            ViewController.locationManager.stopUpdatingLocation()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Konum alınamadı. Hata: \(error.localizedDescription)")
    }
}


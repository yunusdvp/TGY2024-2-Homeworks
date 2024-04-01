//
//  WeatherService.swift
//  HavaDurumu
//
//  Created by Yunus Emre ÖZŞAHİN on 1.04.2024.
//

import Foundation

class WeatherService {
    static func fetchCurrentData(latitude: Double, longitude: Double, apiKey: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        let apiUrlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        
        if let apiUrl = URL(string: apiUrlString) {
            let task = URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let data = data else {
                    completion(nil, NSError(domain: "WeatherService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Veri bulunamadı"]))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        completion(json, nil)
                    } else {
                        completion(nil, NSError(domain: "WeatherService", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON dönüşüm hatası"]))
                    }
                } catch let error {
                    completion(nil, error)
                }
            }
            
            task.resume()
        } else {
            completion(nil, NSError(domain: "WeatherService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Geçersiz API URL'si"]))
        }
    }
}

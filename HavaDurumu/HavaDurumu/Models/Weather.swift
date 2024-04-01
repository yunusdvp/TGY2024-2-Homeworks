//
//  Weather.swift
//  HavaDurumu
//
//  Created by Yunus Emre ÖZŞAHİN on 30.03.2024.
//


import Foundation
struct Weather {
    let temperature: Double
    let humidity: Int
    let description: String
    let name: String
    let icon: String
    // JSON'dan Weather struct'ını oluşturma
    init?(json: [String: Any]) {
        guard let main = json["main"] as? [String: Any],
              let temperature = main["temp"] as? Double,
              let humidity = main["humidity"] as? Int,
              let weatherArray = json["weather"] as? [[String: Any]],
              let weather = weatherArray.first,
              let name = json["name"] as? String,
              let icon = weather["icon"] as? String,
              let description = weather["description"] as? String else
            {
            return nil
        }
                
        
        self.temperature = temperature
        self.humidity = humidity
        self.description = description
        self.name = name
        self.icon = icon
    }
}
struct HourlyWeatherData {
    let time: Date
    let temperature: Double
    let humidity: Int
    let weatherDescription: String
    let precipitationProbability: Double
}
struct DailyWeatherData {
    let date: Date
    var hourlyData: [HourlyWeatherData]
}

//
//  NetworkHelper.swift
//  HavaDurumu
//
//  Created by Yunus Emre ÖZŞAHİN on 31.03.2024.
//
import Foundation


var weeklyWeatherData: [DailyWeatherData] = []

func fetchWeatherData(latitude: Double, longitude: Double, apiKey: String) {
    let apiUrlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"

    if let apiUrl = URL(string: apiUrlString) {
        let task = URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            if let error = error {
                print("Hata: \(error)")
                return
            }

            guard let data = data else {
                print("Veri bulunamadı")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let list = json["list"] as? [[String: Any]] {
                    var dailyWeatherData: [WeatherData] = []

                    for item in list {
                        if let dt_txt = item["dt_txt"] as? String,
                           let main = item["main"] as? [String: Any],
                           let temp = main["temp"] as? Double,
                           let humidity = main["humidity"] as? Int,
                           let weatherArray = item["weather"] as? [[String: Any]],
                           let weather = weatherArray.first,
                           let weatherDescription = weather["description"] as? String,
                           let pop = item["pop"] as? Double {

                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let date = dateFormatter.date(from: dt_txt)

                            let weatherData = WeatherData(date: date ?? Date(), temperature: temp, humidity: humidity, weatherDescription: weatherDescription, precipitationProbability: pop)
                            dailyWeatherData.append(weatherData)
                        }
                    }

                    // Verileri işle
                    
                    //print("Daily Weather Data: \(dailyWeatherData)")

                    weeklyWeatherData = processWeatherData(dailyWeatherData)
                    print(weeklyWeatherData)
                    
                }
            } catch let error {
                print("JSON dönüşüm hatası: \(error)")
            }
        }

        task.resume()
    } else {
        print("Geçersiz API URL'si")
    }
}


func printWeeklyWeatherData(_ weeklyWeatherData: [[WeatherData]]) {
    for (index, dailyData) in weeklyWeatherData.enumerated() {
        print("Gün \(index + 1):")
        for data in dailyData {
            print("- Tarih: \(data.date), Sıcaklık: \(data.temperature), Nem: \(data.humidity), Hava Durumu: \(data.weatherDescription), Yağış Olasılığı: \(data.precipitationProbability)")
        }
    }
}




func fetchCurrentData(latitude: Double, longitude: Double, apiKey: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
    // API URL'si oluşturma
    let apiUrlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&lang=tr"
    
    // API'ye GET isteği gönderme
    if let apiUrl = URL(string: apiUrlString) {
        let task = URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            // Hata kontrolü
            if let error = error {
                completion(nil, error)
                return
            }
            
            // Veri kontrolü
            guard let data = data else {
                completion(nil, NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Veri bulunamadı"]))
                return
            }
            
            do {
                // JSON verisini dönüştürme
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Weather struct'ını oluşturma
                    if let weather = Weather(json: json) {
                        // Alınan verileri kullanma
                        let weatherData: [String: Any] = [
                            "temperature": weather.temperature,
                            "humidity": weather.humidity,
                            "description": weather.description,
                            "name": weather.name,
                            "icon": weather.icon
                        ]
                        completion(weatherData, nil)
                    } else {
                        completion(nil, NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Weather struct'ı oluşturulamadı"]))
                    }
                }
            } catch let error {
                completion(nil, error)
            }
        }
        
        // İsteği başlatma
        task.resume()
    } else {
        completion(nil, NSError(domain: "URLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Geçersiz API URL'si"]))
    }
}

// Verileri işlemek için kullanılacak fonksiyon
func processWeatherData(_ weatherData: [WeatherData]) -> [DailyWeatherData] {
    var dailyWeatherData: [DailyWeatherData] = []
    var currentDate = ""

    var hourlyDataForCurrentDay: [HourlyWeatherData] = []

    for data in weatherData {
        let dateStr = formatDateToString(data.date)

        // Tarih değiştiyse, mevcut günlük veriyi oluştur ve dailyWeatherData'ya ekle
        if dateStr != currentDate {
            if !hourlyDataForCurrentDay.isEmpty {
                let newDailyData = DailyWeatherData(date: hourlyDataForCurrentDay.first!.time, hourlyData: hourlyDataForCurrentDay)
                dailyWeatherData.append(newDailyData)
                hourlyDataForCurrentDay = []
            }
            currentDate = dateStr
        }

        let hourlyData = HourlyWeatherData(time: data.date, temperature: data.temperature, humidity: data.humidity, weatherDescription: data.weatherDescription, precipitationProbability: data.precipitationProbability)
        hourlyDataForCurrentDay.append(hourlyData)
    }

    // Mevcut günün son verilerini ekle
    if !hourlyDataForCurrentDay.isEmpty {
        let newDailyData = DailyWeatherData(date: hourlyDataForCurrentDay.first!.time, hourlyData: hourlyDataForCurrentDay)
        dailyWeatherData.append(newDailyData)
    }

    // Günlük verileri tarihe göre sırala
    let sortedDailyData = dailyWeatherData.sorted { $0.date < $1.date }

    return sortedDailyData
}



func formatDateToString(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
}


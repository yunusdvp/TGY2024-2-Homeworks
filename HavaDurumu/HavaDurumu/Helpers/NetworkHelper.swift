import Foundation

// Weather struct'ı
struct Weather {
    let date: String
    let temperature: (min: Double, max: Double)
    let humidity: Int
    let weatherDescription: String
    let precipitationProbability: Double
    
    init?(json: [String: Any]) {
        guard let dateText = json["dt_txt"] as? String,
              let main = json["main"] as? [String: Any],
              let tempMin = main["temp_min"] as? Double,
              let tempMax = main["temp_max"] as? Double,
              let humidity = main["humidity"] as? Int,
              let weatherArray = json["weather"] as? [[String: Any]],
              let weather = weatherArray.first,
              let description = weather["description"] as? String,
              let pop = json["pop"] as? Double else {
            return nil
        }
        
        self.date = dateText
        self.temperature = (min: tempMin, max: tempMax)
        self.humidity = humidity
        self.weatherDescription = description
        self.precipitationProbability = pop
    }
}

// API çağrısı fonksiyonu
func fetchFiveDayForecast(latitude: Double, longitude: Double, apiKey: String) {
    // API URL'si oluşturma
    let apiUrlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
    
    // API'ye GET isteği gönderme
    if let apiUrl = URL(string: apiUrlString) {
        let task = URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            // Hata kontrolü
            if let error = error {
                print("Hata: \(error)")
                return
            }
            
            // Veri kontrolü
            guard let data = data else {
                print("Veri bulunamadı")
                return
            }
            
            do {
                // JSON verisini dönüştürme
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let forecastList = json["list"] as? [[String: Any]] {
                    
                    // Hava durumu verilerini saklamak için boş bir dizi oluşturma
                    var forecasts = [Weather]()
                    
                    // JSON'dan Weather nesnelerini oluşturma
                    for forecast in forecastList {
                        if let weather = Weather(json: forecast) {
                            forecasts.append(weather)
                        }
                    }
                    
                    // Alınan verileri kullanma
                    for forecast in forecasts {
                        print("Tarih: \(forecast.date)")
                        print("En Düşük Sıcaklık: \(forecast.temperature.min) Kelvin")
                        print("En Yüksek Sıcaklık: \(forecast.temperature.max) Kelvin")
                        print("Nem: \(forecast.humidity)%")
                        print("Hava Durumu: \(forecast.weatherDescription)")
                        print("Yağış Olasılığı: \(forecast.precipitationProbability)")
                        print("---------------------------------------")
                    }
                }
            } catch let error {
                print("JSON dönüşüm hatası: \(error)")
            }
        }
        
        // İsteği başlatma
        task.resume()
    } else {
        print("Geçersiz API URL'si")
    }
}

// Örnek kullanım
let latitude = 44.34
let longitude = 10.99
let apiKey = "YOUR_API_KEY"

//fetchFiveDayForecast(latitude: latitude, longitude: longitude, apiKey: apiKey)

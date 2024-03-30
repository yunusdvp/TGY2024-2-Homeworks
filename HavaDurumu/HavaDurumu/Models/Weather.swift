
/*
struct Weather {
    let temperature: Double
    let humidity: Int
    let main: String
    
    // JSON'dan Weather struct'ını oluşturma
    init?(json: [String: Any]) {
        guard let main = json["main"] as? [String: Any],
              let temperature = main["temp"] as? Double,
              let humidity = main["humidity"] as? Int,
              let weatherArray = json["weather"] as? [[String: Any]],
              let weather = weatherArray.first,
              let description = weather["description"] as? String else {
            return nil
        }
        
        self.temperature = temperature
        self.humidity = humidity
    }
}

*/

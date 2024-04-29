//
//  createRandomData.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 23.04.2024.
//

import Foundation
import Firebase
func uploadJourneysToFirestore(journeys: [Journey]) {
    let db = Firestore.firestore()
    
    for journey in journeys {
        let departureDateDict: [String: Any] = [
            "day": journey.departureDate.day,
            "month": journey.departureDate.month,
            "year": journey.departureDate.year,
            "hour": journey.departureDate.hour,
            "minute": journey.departureDate.minute
        ]
        
        let seatsData = journey.seats.map { seat -> [String: Any] in
            [
                "no": seat.no,
                "isEmpty": seat.isEmpty,
                "passengerGender": seat.passengerGender as Any
            ]
        }

        let docData: [String: Any] = [
            "fromCity": journey.fromCity.cityName,
            "toCity": journey.toCity.cityName,
            "company": journey.journeyCompany.companyName,
            "departureDate": departureDateDict,
            "price": journey.price,
            "capacity": journey.seatCapacity,
            "travelDuration": journey.travelDuration,
            "seats": seatsData  
        ]
        
        db.collection("journeys").addDocument(data: docData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }
}


func calculatePriceBasedOnDuration(duration: Int) -> Int {
    switch duration {
    case 0..<3:
        return Int.random(in: 200...300)
    case 3..<6:
        return Int.random(in: 400...600)
    case 6..<12:
        return Int.random(in: 750...1000)
    case 12...:
        return Int.random(in: 1000...1300)
    default:
        return 200
    }
}

// Rastgele yolculuklar üretme fonksiyonu
func generateRandomJourneys() -> [Journey] {
    let cities = ["Mersin", "Adana", "İstanbul", "Ankara"]
    let companies = [
        BusCompany(companyName: "Metro Turizm"),
        BusCompany(companyName: "Villa"),
        BusCompany(companyName: "Pamukkale Seyahat"),
        BusCompany(companyName: "Kamil Koç"),
        BusCompany(companyName: "Varan Seyahat"),
        BusCompany(companyName: "Kontur")
    ]
    let capacities = [40, 42, 43, 45, 43, 42]

    var journeys = [Journey]()

    for _ in 1...800 {
        let fromCityName = cities.randomElement()!
        let toCityName = cities.filter { $0 != fromCityName }.randomElement()!
        let companyIndex = Int.random(in: 0..<companies.count)
        let capacity = capacities[companyIndex]

        var seats: [Seat] = []
        for i in 1...capacity {
            seats.append(Seat(no: i, isEmpty: true, passengerGender: nil))
        }

        let startDate = DateStruct(day: Int.random(in: 1...10), month: 5, year: 2024, minute: Int.random(in: 0...59), hour: Int.random(in: 0...23))
        let journeyTime = calculateTravelTime(fromCity: fromCityName, toCity: toCityName)
        let price = calculatePriceBasedOnDuration(duration: journeyTime)

        let journey = Journey(
            fromCity: City(cityName: fromCityName),
            toCity: City(cityName: toCityName),
            journeyCompany: companies[companyIndex],
            departureDate: startDate,
            seatCapacity: capacity,
            price: price,
            travelDuration: journeyTime,
            seats: seats
        )
        
        journeys.append(journey)
    }

    return journeys
}

func calculateTravelTime(fromCity: String, toCity: String) -> Int {
    let travelTimes = [
        ("Mersin", "Adana", 1),
        ("Mersin", "Ankara", 5),
        ("Mersin", "İstanbul", 13),
        ("Adana", "İstanbul", 13),
        ("Adana", "Mersin", 1),
        ("Adana", "Ankara", 5),
        ("Ankara", "Mersin", 5),
        ("Ankara", "İstanbul", 4),
        ("Ankara", "Adana", 5),
        ("İstanbul", "Ankara", 4),
        ("İstanbul", "Adana", 13),
        ("İstanbul", "Mersin", 13)
    ]
    return travelTimes.first { $0.0 == fromCity && $0.1 == toCity }?.2 ?? 0
}

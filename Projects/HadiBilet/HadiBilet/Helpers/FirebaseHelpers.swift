//
//  FirebaseHelpers.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 22.04.2024.
//

import Foundation
// Örnek FirebaseHelpers.swift

import Firebase

class FirebaseHelpers {
    let db = Firestore.firestore()
    
    static func getUserDataFromFirebase(completion: @escaping (User?, Error?) -> Void) {
        // Firebase'den kullanıcı verilerini alma işlemi
        // Örnek kod
        let currentUser = Auth.auth().currentUser
        
        // Kullanıcı verilerini döndürme
        if let user = currentUser {
            // Kullanıcı verilerini alarak completion closure'ına geçirme
            completion(user, nil)
        } else {
            // Hata durumunda hata geçirme
            completion(nil, NSError(domain: "YourAppDomain", code: 404, userInfo: ["message": "User not found"]))
        }
    }
    func addPassengerToFirestore(passenger: Passenger) {
        // Firestore koleksiyonunu ve belgeyi belirleyin
        let passengersCollection = db.collection("passengers")
        
        // Yeni bir belge referansı oluşturun (Firestore otomatik olarak belge ID'si atayacak)
        var newPassengerRef: DocumentReference? = nil
        
        // Yeni bir belge oluşturun ve verileri ekleyin
        newPassengerRef = passengersCollection.addDocument(data: [
            "name": passenger.name ?? "",       // name değeri, passenger.name'in değeri olacak veya boş bir string
            "surname": passenger.surname ?? "",
            "id": passenger.id ?? ""// surname değeri, passenger.surname'un değeri olacak veya boş bir string
        ]) { error in
            if let error = error {
                print("Hata oluştu, belge eklenemedi: \(error)")
            } else {
                print("Yeni belge eklendi. Belge ID: \(newPassengerRef!.documentID)")
            }
        }
    }
    func fetchFilteredJourneys(fromCity: String, toCity: String, departureDay: Int, departureMonth: Int, completion: @escaping ([Journey]) -> Void) {
        let db = Firestore.firestore()
        let query = db.collection("journeys")
            .whereField("fromCity", isEqualTo: fromCity)
            .whereField("toCity", isEqualTo: toCity)
            .whereField("departureDate.day", isEqualTo: departureDay)
            .whereField("departureDate.month", isEqualTo: departureMonth)

        query.getDocuments { (snapshot, error) in
            var journeys: [Journey] = []
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
                return
            }

            // Güvenli bir şekilde snapshot'ı unwrap et
            guard let documents = snapshot?.documents else {
                print("No documents found")
                completion([])
                return
            }

            for document in documents {
                let data = document.data()
                if let fromCityName = data["fromCity"] as? String,
                   let toCityName = data["toCity"] as? String,
                   let companyName = data["company"] as? String,
                   let departureData = data["departureDate"] as? [String: Any],
                   let capacity = data["capacity"] as? Int,
                   let price = data["price"] as? Int,
                   let travelDuration = data["travelDuration"] as? Int,
                   let seatsArray = data["seats"] as? [[String: Any]] {

                    let journey = Journey(
                        fromCity: City(cityName: fromCityName),
                        toCity: City(cityName: toCityName),
                        journeyCompany: BusCompany(companyName: companyName),
                        departureDate: self.parseDate(departureData),
                        seatCapacity: capacity,
                        price: price,
                        travelDuration: travelDuration,
                        seats: self.parseSeats(seatsArray)
                    )
                    journeys.append(journey)
                }
            }
            completion(journeys)
        }
    }


    func parseDate(_ dateDict: [String: Any]) -> DateStruct {
        return DateStruct(
            day: dateDict["day"] as? Int ?? 0,
            month: dateDict["month"] as? Int ?? 0,
            year: dateDict["year"] as? Int ?? 0,
            minute: dateDict["minute"] as? Int ?? 0,
            hour: dateDict["hour"] as? Int ?? 0
        )
    }

    func parseSeats(_ seatsArray: [[String: Any]]) -> [Seat] {
        return seatsArray.compactMap { seatDict in
            if let no = seatDict["no"] as? Int,
               let isEmpty = seatDict["isEmpty"] as? Bool {
                return Seat(no: no, isEmpty: isEmpty, passengerGender: seatDict["passengerGender"] as? Bool)
            }
            return nil
        }
    }

    func calculateArrivalDate(from departureDate: DateStruct, duration: Int) -> DateStruct {
        var arrivalDate = departureDate
        arrivalDate.hour += duration
        while arrivalDate.hour >= 24 {
            arrivalDate.hour -= 24
            arrivalDate.day += 1
            // Handle end of month/year transitions if needed
        }
        return arrivalDate
    }
}


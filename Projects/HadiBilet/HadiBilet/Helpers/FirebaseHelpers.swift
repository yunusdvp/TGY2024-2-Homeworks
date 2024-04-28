//
//  FirebaseHelpers.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 22.04.2024.
//

import Foundation


import Firebase

class FirebaseHelpers {
    let db = Firestore.firestore()
    
    static func getUserDataFromFirebase(completion: @escaping (User?, Error?) -> Void) {
        
        let currentUser = Auth.auth().currentUser
        
        // Kullanıcı verilerini döndürme
        if let user = currentUser {
            
            completion(user, nil)
        } else {
            
            completion(nil, NSError(domain: "YourAppDomain", code: 404, userInfo: ["message": "User not found"]))
        }
    }
    func addPassengerToFirestore(passenger: Passenger) {
        
        let passengersCollection = db.collection("passengers")
        var newPassengerRef: DocumentReference? = nil
        newPassengerRef = passengersCollection.addDocument(data: [
            "name": passenger.name ?? "",
            "surname": passenger.surname ?? "",
            "id": passenger.id ?? ""
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
                        id: document.documentID,
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
            
        }
        return arrivalDate
    }

    func updateSeatInJourney(journeyId: String, updatedSeat: Seat, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let journeyRef = db.collection("journeys").document(journeyId)
        journeyRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var journey = document.data()
                if var seats = journey?["seats"] as? [[String: Any]] {
                    
                    if let index = seats.firstIndex(where: { ($0["no"] as? Int) == updatedSeat.no }) {
                        var seatData = seats[index]
                        seatData["isEmpty"] = updatedSeat.isEmpty
                        seatData["passengerGender"] = updatedSeat.passengerGender
                        if let passenger = updatedSeat.passenger {
                            seatData["passenger"] = ["id": passenger.id, "name": passenger.name, "surname": passenger.surname]
                        }
                        seats[index] = seatData
                    }
                    journeyRef.updateData(["seats": seats]) { error in
                        if let error = error {
                            print("Error updating seats: \(error)")
                            completion(false)
                        } else {
                            print("Seats updated successfully")
                            completion(true)
                        }
                    }
                }
            } else {
                print("Document does not exist or failed to fetch journey")
                completion(false)
            }
        }
    }

}


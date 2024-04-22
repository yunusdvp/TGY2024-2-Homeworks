//
//  ViewController.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 22.04.2024.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Firebase projeniz için konfigürasyonu yapılandırın
        //FirebaseApp.configure()
        let newPassenger = Passenger(id: "123456",name:"Yunus Emre",surname: "Doe")
        // Firestore referansını alın
        addPassengerToFirestore(passenger: newPassenger)

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
}


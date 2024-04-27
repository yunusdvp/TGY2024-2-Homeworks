//
//  ViewController.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 22.04.2024.
//

import UIKit
import Foundation
import Firebase
class ViewController: UIViewController {
    @IBOutlet weak var JourneysTableView: UITableView!
    let firebaseHelpers = FirebaseHelpers()
    var nereden : String?
    var nereye : String?
    var day: Int?
    var month: Int?

    var journeys = [Journey]()
    override func viewDidLoad() {
        super.viewDidLoad()
        JourneysTableView.dataSource = self
        JourneysTableView.delegate = self
        JourneysTableView.register(UINib(nibName: JourneyCell.identifier, bundle: nil), forCellReuseIdentifier: JourneyCell.identifier)
        firebaseHelpers.fetchFilteredJourneys(fromCity: "\(nereden ?? "")", toCity: "\(nereye ?? "")", departureDay: day ?? 0, departureMonth: month ?? 0) { [weak self] journeys in
            guard let self else { return }
            DispatchQueue.main.async {
                print(journeys)
                self.updateUI(with: journeys)
                
            }
        }
        /*DispatchQueue.main.async {
            self.firebaseHelpers.fetchFilteredJourneys(fromCity: "Mersin", toCity: "Adana", departureDay: 3, departureMonth: 5) { [weak self] journeys in
                DispatchQueue.main.async {
                    print(journeys)
                }
            }
         
         }*/
        
        
        
        
        // Firebase projeniz için konfigürasyonu yapılandırın
        //FirebaseApp.configure()
        /*let newPassenger = Passenger(id: "123456",name:"Yunus Emre",surname: "Doe")
         firebaseHelpers.addPassengerToFirestore(passenger: newPassenger)        // Firestore referansını alın
         //addPassengerToFirestore(passenger: newPassenger)*/
        //FirebaseApp.configure()
        
        
        
    }
    func updateUI(with journeys: [Journey]) {
        // Burada collectionView ya da tableView'ınızı güncelleyebilirsiniz
        self.journeys = journeys
        self.JourneysTableView.reloadData()  // Veya self.collectionView.reloadData()
    }
    
}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        journeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JourneyCell.identifier, for: indexPath) as? JourneyCell else {
            return UITableViewCell()
        }
        cell.configure(with: journeys[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToBusTicket", sender: indexPath)
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToBusTicket" {
                if let destinationVC = segue.destination as? BusTicketViewController,
                   let indexPath = sender as? IndexPath {
                    destinationVC.journey = journeys[indexPath.row]
                }
            }
        }

   

    
    
}

    



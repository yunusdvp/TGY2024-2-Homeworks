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
    
    let emptyLabel = UILabel()
    let firebaseHelpers = FirebaseHelpers()
    var nereden : String?
    var nereye : String?
    var day: Int?
    var month: Int?
    var journeys = [Journey]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmptyLabel()
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
    }
    func checkEmptyState() {
        emptyLabel.isHidden = !journeys.isEmpty
    }
    func setupEmptyLabel() {
            emptyLabel.text = "Üzgünüz, belirttiğiniz kriterlerde sefer bulunamamıştır."
            emptyLabel.textColor = .gray
            emptyLabel.textAlignment = .center
            emptyLabel.numberOfLines = 0
            emptyLabel.isHidden = true
            JourneysTableView.addSubview(emptyLabel)
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: JourneysTableView.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: JourneysTableView.centerYAnchor),
                emptyLabel.widthAnchor.constraint(equalTo: JourneysTableView.widthAnchor, multiplier: 0.8)
            ])
        }
    func updateUI(with journeys: [Journey]) {
        let now = Date()
        let calender = Calendar.current
        self.journeys = journeys.filter { journey in
                let journeyDate = dateFrom(dateStruct: journey.departureDate)
                return journeyDate >= now
            }.sorted {
                if $0.departureDate.hour != $1.departureDate.hour {
                    return $0.departureDate.hour < $1.departureDate.hour
                } else {
                    return $0.departureDate.minute < $1.departureDate.minute
                }
            }
        self.JourneysTableView.reloadData()
        checkEmptyState()
    }
    func dateFrom(dateStruct: DateStruct) -> Date {
        var components = DateComponents()
        components.year = dateStruct.year
        components.month = dateStruct.month
        components.day = dateStruct.day
        components.hour = dateStruct.hour
        components.minute = dateStruct.minute
        let calendar = Calendar.current
        return calendar.date(from: components) ?? Date()
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

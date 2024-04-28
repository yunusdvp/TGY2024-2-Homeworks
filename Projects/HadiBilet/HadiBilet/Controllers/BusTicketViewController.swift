//
//  BusTicketViewController.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 27.04.2024.
//

import UIKit

class BusTicketViewController: UIViewController {
    var journey :Journey?
    
    @IBOutlet weak var passengeerInfoView: PassengerInfoView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var busSeatCollectionView: UICollectionView!
    @IBOutlet weak var busFrontImage: UIImageView!
    
    let firebaseHelpers = FirebaseHelpers()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(journey)
        configureCollectionView()
        //let passenger = Passenger(id: "p123", name: "Yunus", surname: "Özşahin")
        
        /*let updatedSeat = Seat(no: 1, isEmpty: false, passengerGender: true, passenger: passenger)
         firebaseHelpers.updateSeatInJourney(journeyId: "03KNCTMnXdPFBFPPysCf", updatedSeat: updatedSeat) { success in
         if success {
         print("Seat updated successfully")
         } else {
         print("Failed to update seat")
         }
         }*/
        
    }
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        busSeatCollectionView.setCollectionViewLayout(layout, animated: true)
        busSeatCollectionView.delegate = self
        busSeatCollectionView.dataSource = self
        busSeatCollectionView.register(UINib(nibName: "SeatCell", bundle: nil), forCellWithReuseIdentifier: SeatCell.identifier)
        busSeatCollectionView.allowsMultipleSelection = true
        
    }
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi Eksik", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func arePassengerDetailsFilled() -> Bool {
        return !(passengeerInfoView.passengerIdTextField.text?.isEmpty ?? true) &&
        !(passengeerInfoView.passengerNameTextField.text?.isEmpty ?? true) &&
        !(passengeerInfoView.passengerSurnameTextField.text?.isEmpty ?? true) &&
        (passengeerInfoView.passengerGenderControl.selectedSegmentIndex != UISegmentedControl.noSegment)
    }
    @IBAction func BuyTicketButton(_ sender: UIButton) {
        guard arePassengerDetailsFilled() else {
            showAlert(message: "Lütfen önce yolcu bilgilerini doldurun.")
            return
        }
        
        guard let selectedSeats = busSeatCollectionView.indexPathsForSelectedItems, !selectedSeats.isEmpty else {
            showAlert(message: "Lütfen en az bir koltuk seçin.")
            return
        }
            var updatedSeats = [Seat]()
            var selectedIndexes = [Int]()
            
            for indexPath in selectedSeats {
                guard var seat = self.journey?.seats[indexPath.row] else {
                    continue
                }
                
                seat.isEmpty = false
                seat.passengerGender = self.passengeerInfoView.passengerGenderControl.selectedSegmentIndex == 0
                seat.passenger = Passenger(
                    id: self.passengeerInfoView.passengerIdTextField.text,
                    name: self.passengeerInfoView.passengerNameTextField.text,
                    surname: self.passengeerInfoView.passengerSurnameTextField.text
                )
                updatedSeats.append(seat)
                selectedIndexes.append(indexPath.row)
            }
            
            // Güncelleme işlemini başlat
            self.firebaseHelpers.updateSelectedSeatsInJourney(journeyId: self.journey?.id ?? "", seats: updatedSeats, selectedIndexes: selectedIndexes) { success in
                if success {
                    print("All selected seats updated successfully.")
                } else {
                    print("Failed to update selected seats")
                }
            }
    }
}
extension BusTicketViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(journey?.seatCapacity)
        return (journey?.seats.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeatCell.identifier, for: indexPath) as? SeatCell else {
            fatalError("Unable to dequeue SeatCell")
        }
        if let seat = journey?.seats[indexPath.row] {
            print(seat)
            cell.configure(with: seat)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let seat = journey?.seats[indexPath.row], seat.isEmpty == false {
            showAlert(message: "Bu koltuk doludur. Boş koltukları seçebilirsiniz.")
            return false
        }
        
        if collectionView.indexPathsForSelectedItems?.count == 5 {
            showAlert(message: "En fazla 5 koltuk seçebilirsiniz.")
            return false
        }
        
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let cell = collectionView.cellForItem(at: indexPath) as? SeatCell,
               let seat = journey?.seats[indexPath.row], arePassengerDetailsFilled() {
                
                let genderIndex = passengeerInfoView.passengerGenderControl.selectedSegmentIndex
                let backgroundColor: UIColor = (genderIndex == 0) ? .blue : .red
                cell.containerView.backgroundColor = backgroundColor
                print("Seçilen koltuk: \(indexPath.row + 1)")
            } else {
                collectionView.deselectItem(at: indexPath, animated: true)
                showAlert(message: "Lütfen önce yolcu bilgilerini doldurun.")
            }
        }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SeatCell {
            cell.containerView.backgroundColor = .lightGray
            
            // Modeli doğrudan güncelle
            if journey?.seats.indices.contains(indexPath.row) == true {
                journey?.seats[indexPath.row].isEmpty = true
                journey?.seats[indexPath.row].passengerGender = nil
                journey?.seats[indexPath.row].passenger = nil
            }
            
            print("Seçimi kaldırılan koltuk: \(indexPath.row + 1)")
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemHeight = collectionView.bounds.height/4
        var itemWidth =  itemHeight
        
        
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
}

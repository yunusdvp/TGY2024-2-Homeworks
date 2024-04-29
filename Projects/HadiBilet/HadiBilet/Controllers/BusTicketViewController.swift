//
//  BusTicketViewController.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 27.04.2024.
//

import UIKit
import CoreData
class BusTicketViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var journey :Journey?
    @IBOutlet weak var passengeerInfoView: PassengerInfoView!
    @IBOutlet weak var busSeatCollectionView: UICollectionView!
    
    let firebaseHelpers = FirebaseHelpers()
    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissKeyboardTapGesture()
        addKeyboardObservers()
        print(journey)
        configureCollectionView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerReferenceSize = CGSize(width: 50, height: busSeatCollectionView.bounds.height)
        busSeatCollectionView.setCollectionViewLayout(layout, animated: true)
        busSeatCollectionView.delegate = self
        busSeatCollectionView.dataSource = self
        busSeatCollectionView.register(UINib(nibName: "SeatCell", bundle: nil), forCellWithReuseIdentifier: SeatCell.identifier)
        busSeatCollectionView.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.identifier)
        busSeatCollectionView.allowsMultipleSelection = true
        
    }
    private func showAlert(title: String, message: String) {
        AlertManager.shared.showAlert(title: title, message: message, on: self)
    }
    
    func arePassengerDetailsFilled() -> Bool {
        return !(passengeerInfoView.passengerIdTextField.text?.isEmpty ?? true) &&
        !(passengeerInfoView.passengerNameTextField.text?.isEmpty ?? true) &&
        !(passengeerInfoView.passengerSurnameTextField.text?.isEmpty ?? true) &&
        (passengeerInfoView.passengerGenderControl.selectedSegmentIndex != UISegmentedControl.noSegment)
    }
    private func showTicketDetails() {
            guard let journey = self.journey else { return }
            guard let selectedSeats = busSeatCollectionView.indexPathsForSelectedItems, !selectedSeats.isEmpty else { return }
            let seatNumbers = selectedSeats.map { "\($0.row + 1)" }.joined(separator: ", ")
            let formattedDate = formatDateString(journey.departureDate)
            let journeyDetails = "Seyehat Firması: \(journey.journeyCompany.companyName)\n Rota: \(journey.fromCity.cityName) - \(journey.toCity.cityName) \nTarih \(formattedDate),\n Yolculuk süresi(Tahmini): \(journey.travelDuration) saat"
            let ticketInfo = "\(journeyDetails)\nKoltuk: \(seatNumbers)"
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            AlertManager.shared.showAlert(title: "Bilet Detayınız", message: ticketInfo, on: self, actions: [okAction], style: .actionSheet)
        }
        
        private func formatDateString(_ date: DateStruct) -> String {
            let dateComponents = DateComponents(year: date.year, month: date.month, day: date.day, hour: date.hour, minute: date.minute)
            let calendar = Calendar.current
            if let date = calendar.date(from: dateComponents) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .short
                return dateFormatter.string(from: date)
            }
            return "\(date.day)-\(date.month)-\(date.year) saat \(date.hour):\(String(format: "%02d", date.minute))"
        }
    @IBAction func BuyTicketButton(_ sender: UIButton) {
        guard arePassengerDetailsFilled() else {
            showAlert(title: "Uyarı",message: "Lütfen önce yolcu bilgilerini doldurun.")
            return
        }
        
        guard let selectedSeats = busSeatCollectionView.indexPathsForSelectedItems, !selectedSeats.isEmpty else {
            showAlert(title: "Uyarı", message: "Lütfen en az bir koltuk seçin.")
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
            self.firebaseHelpers.updateSelectedSeatsInJourney(journeyId: self.journey?.id ?? "", seats: updatedSeats, selectedIndexes: selectedIndexes) { success in
                if success {
                    print("All selected seats updated successfully.")
                    self.showTicketDetails()
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
            showAlert(title: "Uyarı", message: "Bu koltuk doludur. Boş koltukları seçebilirsiniz.")
            return false
        }
        
        if collectionView.indexPathsForSelectedItems?.count == 5 {
            showAlert(title: "Uyarı", message: "En fazla 5 koltuk seçebilirsiniz.")
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
                showAlert(title: "Uyarı", message: "Lütfen önce yolcu bilgilerini doldurun.")
            }
        }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SeatCell {
            cell.containerView.backgroundColor = .lightGray
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
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }

            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeader.identifier, for: indexPath) as! CollectionHeader
            header.configure(with: UIImage(named: "BusFront")!)
            return header
    }
}

//
//  BusTicketViewController.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 27.04.2024.
//

import UIKit

class BusTicketViewController: UIViewController {
    var journey :Journey?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var busSeatCollectionView: UICollectionView!
    @IBOutlet weak var busFrontImage: UIImageView!
    
    let firebaseHelpers = FirebaseHelpers()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(journey)
        configureCollectionView()
        /*let passenger = Passenger(id: "p123", name: "Yunus", surname: "Özşahin")
        let updatedSeat = Seat(no: 1, isEmpty: false, passengerGender: true, passenger: passenger)
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemHeight = collectionView.bounds.height/4
        var itemWidth =  itemHeight
        
        
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
}

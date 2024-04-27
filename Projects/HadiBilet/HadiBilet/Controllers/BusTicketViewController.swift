//
//  BusTicketViewController.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 27.04.2024.
//

import UIKit

class BusTicketViewController: UIViewController {
    var journey :Journey?
    
    //@IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var busSeatCollectionView: UICollectionView!
    
   // @IBOutlet weak var busFrontImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(journey)
        busSeatCollectionView.delegate = self
        busSeatCollectionView.dataSource = self
        busSeatCollectionView.register(UINib(nibName: "SeatCell", bundle: nil), forCellWithReuseIdentifier: SeatCell.identifier)
        // Do any additional setup after loading the view.
    }
    



}
extension BusTicketViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(journey?.seatCapacity)
        return journey?.seatCapacity ?? 0
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

    
    
    
    
}

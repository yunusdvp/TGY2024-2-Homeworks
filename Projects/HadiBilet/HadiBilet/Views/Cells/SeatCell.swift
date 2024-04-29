//
//  SeatCell.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 26.04.2024.
//

import UIKit


class SeatCell: UICollectionViewCell {
    
    @IBOutlet weak var seatNoLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    private var backgroundImageView: UIImageView?
    static let identifier = "SeatCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBackgroundImageView()
    }
    override init(frame: CGRect) {
           super.init(frame: frame)
       }
       
    required init?(coder: NSCoder) {
           super.init(coder: coder)
           
       }
       
    private func setupBackgroundImageView() {
            let imageView = UIImageView(frame: containerView.bounds)
            imageView.image = UIImage(named: "BusSeatIcon")
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            containerView.insertSubview(imageView, at: 0)
            backgroundImageView = imageView
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.backgroundColor = .gray
        }
        
        func configure(with model: Seat?) {
            
            guard let model = model else {
                containerView.backgroundColor = .gray
                seatNoLabel.text = "N/A"
                return
            }
            containerView.bringSubviewToFront(seatNoLabel)
            seatNoLabel.text = "\(model.no)"
            if model.isEmpty {
                containerView.backgroundColor = .lightGray
            } else {
                containerView.backgroundColor = model.passengerGender ?? false ? .blue : .red
            }
        }

}

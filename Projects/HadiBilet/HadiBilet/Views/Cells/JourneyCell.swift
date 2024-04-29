//
//  JourneyCollectionViewCell.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 23.04.2024.
//
import UIKit

class JourneyCell: UITableViewCell {
    @IBOutlet weak var busCompanyImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    static let identifier = "JourneyCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configure(with journey: Journey) {
        
        priceLabel.text = "\(journey.price) ₺"
        timeLabel.text = String(format: "%02d:%02d", journey.departureDate.hour, journey.departureDate.minute)
        routeLabel.text = "\(journey.fromCity.cityName) - \(journey.toCity.cityName)"
        durationLabel.text = "\(journey.travelDuration) hours"
        busCompanyImage.image = UIImage(named: journey.journeyCompany.companyName) ?? UIImage(named: "defaultBusImage")
    }
}


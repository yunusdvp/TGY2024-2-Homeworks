//
//  JourneyCollectionViewCell.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 23.04.2024.
//

import UIKit

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
        // Fiyat etiketini ayarla
        priceLabel.text = "\(journey.price) ₺"

        // Zaman bilgisini ayarla (örneğin kalkış saati)
        timeLabel.text = String(format: "%02d:%02d", journey.departureDate.hour, journey.departureDate.minute)

        // Rota bilgisini ayarla
        routeLabel.text = "\(journey.fromCity.cityName) - \(journey.toCity.cityName)"

        // Seyahat süresini ayarla
        durationLabel.text = "\(journey.travelDuration) hours"

        // Otobüs şirketinin resmini ayarla
        busCompanyImage.image = UIImage(named: journey.journeyCompany.companyName) ?? UIImage(named: "defaultBusImage")
    }
}


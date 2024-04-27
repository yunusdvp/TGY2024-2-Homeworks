//
//  SeatCell.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 26.04.2024.
//

import UIKit


class SeatCell: UICollectionViewCell {
    
    @IBOutlet weak var seatNoLabel: UILabel!
    static let identifier = "SeatCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configure(with model: Seat?) {
        // Koltuk numarasını güvenli bir şekilde string'e çevir ve ayarla
        seatNoLabel.text = "\(String(describing: model?.no))" // -1, numara yoksa varsayılan değer olarak gösterilebilir veya "N/A"

        // Koltuğun doluluk durumuna ve yolcu cinsiyetine göre arka plan rengini ayarlayın
        if let model = model {
            if !model.isEmpty {
                // Koltuk doluysa, cinsiyet bilgisine göre renk belirle
                backgroundColor = model.passengerGender ?? false ? .blue : .red
            } else {
                // Koltuk boşsa gri göster
                backgroundColor = .gray
            }
        } else {
            // Model nil ise, varsayılan olarak gri yap
            backgroundColor = .gray
        }
    }
}

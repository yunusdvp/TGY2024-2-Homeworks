//
//  Journey.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 22.04.2024.
//

import Foundation

struct Journey {
    var id: String?
    var fromCity: City
    var toCity: City
    var journeyCompany: BusCompany
    var departureDate: DateStruct
    var seatCapacity: Int
    var price: Int
    var travelDuration: Int
    var seats: [Seat]
}


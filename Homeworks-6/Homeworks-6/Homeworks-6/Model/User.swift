//
//  User.swift
//  Homeworks-6
//
//  Created by Yunus Emre ÖZŞAHİN on 27.03.2024.
//

import Foundation

struct User: Decodable {
    
    let name: String?
    let username: String?
    let email: String?
    let company: Company?

}


struct Company: Decodable {
    let name: String?
}


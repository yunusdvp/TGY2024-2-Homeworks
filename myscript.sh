#!/usr/bin/env swift

import Foundation

var users = ["Feyyaz", "Süleyman", "Barış", "Merve"]

// Büyük harfe dönüştürme ve Z'den A'ya doğru sıralama
let sortedUsers = users.map { $0.uppercased() }.sorted(by: { $0 > $1 })

// Yazdırma
for user in sortedUsers {
    print(user)
}





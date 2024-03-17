import Foundation

// MARK: Verilen sayıya göre +-+- yazdıran fonksiyon
func printPM(_ number: Int) {
    var output = ""
    for i in 1...number {
        output += (i % 2 == 0) ? "-" : "+"
    }
    print(output)
}

printPM(5) // +-+-+-
// MARK: Maksimum sayıyı elde eden fonksiyon
func maximizeNumber(_ number: Int) -> String {
    let numberString = String(number)
    
    
    let isPositive = number >= 0
    
    
    let absoluteValue = abs(number)
    
    var maximizedNumberString = ""
    var added = false
    
    if isPositive{
        for ch in numberString {
            
            if let digit = Int(String(ch)) {
                
                if !added && digit < 5 {
                    maximizedNumberString.append("5")
                    added = true
                }
                maximizedNumberString.append(ch)
            }
        }
        
    }else{
        for ch in numberString {
            
            if let digit = Int(String(ch)) {
                
                if !added && digit > 5 {
                    maximizedNumberString.append("5")
                    added = true
                }
                maximizedNumberString.append(ch)
            }
        }
        
    }
    
    // Eğer 5'ten küçük bir basamak yoksa, sayının sonuna 5 ekler
    if !added {
        maximizedNumberString.append("5")
    }
    
    // Sayı negatifse başına "-" ekler
    if !isPositive {
        maximizedNumberString = "-" + maximizedNumberString
    }
    

    return maximizedNumberString
}


print(maximizeNumber(0))
print(maximizeNumber(82))
print(maximizeNumber(-920))




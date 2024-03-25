import UIKit
import Foundation
//MARK: KEYBOARD EXTENSİON
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}


// MARK: EXERCİSM
func twoFer(name: String? = nil) -> String {
    if let name = name {
        if name == "Do-yun" {
            return "One for \(name), one for me."
        } else {
            return "One for \(name), one for me."
        }
    } else {
        return "One for you, one for me."
    }
}

print(twoFer())

//----------------------------------
func toRna(_ dna: String) -> String {
    var rna = ""
    
    for nucleotide in dna {
        switch nucleotide {
        case "G":
            rna.append("C")
        case "C":
            rna.append("G")
        case "T":
            rna.append("A")
        case "A":
            rna.append("U")
        default:
            break
        }
    }
    
    return rna
}
//----------------------------------

struct SpaceAge {
    let seconds: Double
    
    init(_ seconds: Double) {
        self.seconds = seconds
    }
    
    private func age(onPlanet planet: String, withOrbitalPeriod period: Double) -> Double {
        let earthYears = seconds / 31557600
        let planetYears = earthYears / period
        return planetYears
    }
    
    var onEarth: Double {
        return age(onPlanet: "Earth", withOrbitalPeriod: 1.0)
    }
    
    var onMercury: Double {
        return age(onPlanet: "Mercury", withOrbitalPeriod: 0.2408467)
    }
    
    var onVenus: Double {
        return age(onPlanet: "Venus", withOrbitalPeriod: 0.61519726)
    }
    
    var onMars: Double {
        return age(onPlanet: "Mars", withOrbitalPeriod: 1.8808158)
    }
    
    var onJupiter: Double {
        return age(onPlanet: "Jupiter", withOrbitalPeriod: 11.862615)
    }
    
    var onSaturn: Double {
        return age(onPlanet: "Saturn", withOrbitalPeriod: 29.447498)
    }
    
    var onUranus: Double {
        return age(onPlanet: "Uranus", withOrbitalPeriod: 84.016846)
    }
    
    var onNeptune: Double {
        return age(onPlanet: "Neptune", withOrbitalPeriod: 164.79132)
    }
}
//-------------------------------------------------------
class ETL {
    static func transform(_ old: [String: [String]]) -> [String: Int] {
        var newDictionary: [String: Int] = [:]

        
        for (score, letters) in old {
            
            for letter in letters {
                newDictionary[letter.lowercased()] = Int(score)
            }
        }

        return newDictionary
    }
}
//--------------------------------------------------------
struct Clock: Equatable, CustomStringConvertible {
    var hours: Int
    var minutes: Int
    
    init(hours: Int, minutes: Int = 0) {
        let totalMinutes = (hours * 60 + minutes) % (24 * 60)
        self.hours = (totalMinutes + 24 * 60) / 60 % 24
        self.minutes = (totalMinutes + 24 * 60) % 60
    }
    
    func add(minutes: Int) -> Clock {
        var newHours = self.hours
        var newMinutes = self.minutes + minutes
        if newMinutes >= 60 {
            newHours += newMinutes / 60
            newMinutes %= 60
        }
        return Clock(hours: newHours, minutes: newMinutes)
    }
    
    func subtract(minutes: Int) -> Clock {
        var newHours = self.hours
        var newMinutes = self.minutes - minutes
        if newMinutes < 0 {
            newHours -= 1
            newMinutes += 60
        }
        if newHours < 0 {
            newHours += 24
        }
        return Clock(hours: newHours, minutes: newMinutes)
    }
    
    var description: String {
        let hourString = String(format: "%02d", hours)
        let minuteString = String(format: "%02d", minutes)
        return "\(hourString):\(minuteString)"
    }
}
// MARK: EULAR 8
let numberString = """
73167176531330624919225119674426574742355349194934
96983520312774506326239578318016984801869478851843
85861560789112949495459501737958331952853208805511
12540698747158523863050715693290963295227443043557
66896648950445244523161731856403098711121722383113
62229893423380308135336276614282806444486645238749
30358907296290491560440772390713810515859307960866
70172427121883998797908792274921901699720888093776
65727333001053367881220235421809751254540594752243
52584907711670556013604839586446706324415722155397
53697817977846174064955149290862569321978468622482
83972241375657056057490261407972968652414535100474
82166370484403199890008895243450658541227588666881
16427171479924442928230863465674813919123162824586
17866458359124566529476545682848912883142607690042
24219022671055626321111109370544217506941658960408
07198403850962455444362981230987879927244284909188
84580156166097919133875499200524063689912560717606
05886116467109405077541002256983155200055935729725
71636269561882670428252483600823257530420752963450
"""

// Yeni satır karakterlerini kaldırarak ve diziye dönüştürerek rakamları içeren bir dizi elde edilir
let digits = numberString.filter { $0.isNumber }.map { Int(String($0)) ?? 0 }

var maxProduct = 0
var temporaryProduct = 1

// İlk 13 rakamın çarpımını hesaplayan döngü
for i in 0..<13 {
    temporaryProduct *= digits[i]
}

maxProduct = temporaryProduct

// Ardışık 13 rakamın maksimum çarpımını bulmak için kayan pencere yöntemi kullanılır. yani dizimiz sürekli kaydırılarak en büyük değer elde edilmeye çalışılır.
for i in 1...(digits.count - 13) {
    if digits[i - 1] == 0 {
        temporaryProduct = 1
        for j in i..<i + 13 {
            temporaryProduct *= digits[j]
        }
    } else {
        temporaryProduct = (temporaryProduct / digits[i - 1]) * digits[i + 12]
    }
    
    if temporaryProduct > maxProduct {
        maxProduct = temporaryProduct
    }
}

print("Ardışık 13 basamağın maksimum çarpımı: \(maxProduct)")
//MARK: EULAR 9
/*Pythagorean üçlüsü olan (a, b, c) için aşağıdaki formulü uygulayabiliriz:
 
 a = m^2 - n^2
 b = 2 * m * n
 c = m^2 + n^2

 Burada m ve n tam sayılardır ve m > n'dir.

*/
func findPythagoreanTriplet(sumValue: Int) -> (Int, Int, Int)? {
    for m in 2..<Int(sqrt(Double(sumValue / 2))) {
        for n in 1..<m {
            let a = m * m - n * n
            let b = 2 * m * n
            let c = m * m + n * n
            
            if a + b + c == sumValue {
                return (a, b, c)
            }
        }
    }
    return nil
}
let sum = 1000
if let triplet = findPythagoreanTriplet(sumValue: sum) {
    let (a, b, c) = triplet
    let product = a * b * c
    print("Toplam değeri \(sum) olan Pythagorean üçlüsü: (\(a), \(b), \(c)), Çarpımı: \(product)")
} else {
    print("Toplam değeri \(sum) olan Pythagorean üçlüsü bulunamadı.")
}
//MARK: EULAR 10
func sieveOfEratosthenes(_ upperBound: Int) -> [Int] {
    var sieve = Array(repeating: true, count: upperBound)
    var primes: [Int] = []
    
    sieve[0] = false
    sieve[1] = false
    
    var p = 2
    while p * p <= upperBound {
        if sieve[p] == true {
            for i in stride(from: p * p, to: upperBound, by: p) {
                sieve[i] = false
            }
        }
        p += 1
    }
    
    for (index, isPrime) in sieve.enumerated() {
        if isPrime {
            primes.append(index)
        }
    }
    
    return primes
}

let upperBound = 2_000_000
let primes = sieveOfEratosthenes(upperBound)
let sumOfPrimes = primes.reduce(0, +)

print("Toplamı: \(sumOfPrimes)")



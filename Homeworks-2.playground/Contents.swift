import Foundation


let totalDevelopers = 24
let onlySwiftDevelopers = 12
let onlyKotlinDevelopers = 8

let bothLanguagesDevelopers = totalDevelopers - onlySwiftDevelopers - onlyKotlinDevelopers

print( bothLanguagesDevelopers)




// Palindrom olup olmadığını kontrol eden fonksiyon
func isPalindrome(_ num: Int) -> Bool {
    let numString = String(num)
    return numString == String(numString.reversed())
}

var largestPalindrome = 0

// En büyük palindromun çarpanlarını tutan tuple
var factors: (Int, Int) = (0, 0)

// 999'dan başlayarak 100'e kadar olan sayıları kontrol eder.
for i in stride(from: 999, through: 100, by: -1) {
    // i'den başlayarak 100'e kadar olan sayıları azalan şekilde kontrol eden iç içe geçmiş döngü
    for j in stride(from: i, through: 100, by: -1) {
        // İki sayının çarpımını hesapla
        let product = i * j
        
        // Eğer hesaplanan çarpım, şu ana kadar bulunan en büyük palindromdan küçük veya eşitse, iç döngüyü sonlandır.
        if product <= largestPalindrome {
            break
        }
        
        // Hesaplanan çarpımın bir palindrom olup olmadığını ve daha önce bulunan en büyük palindromdan büyük olup olmadığını kontrol et
        if isPalindrome(product) && product > largestPalindrome {
            
            largestPalindrome = product
            
            factors = (i, j)
        }
    }
}


print("3 basamaklı iki sayının çarpımından elde edilen en büyük palindrom:", largestPalindrome)
print("The factors are:", factors)


//EULAR Project 5.soru teorik olarak çalışması gerekiyor fakat. Algoritmik olarak çok yetersiz bir çözüm. İstenilen sayıyı bulması çok uzun zaman alıyor.

/*var result = 20 // En küçük ortak kat 20'nin katı olacaktır.

while true {
    var divisible = true
    for i in 2...20 {
        if result % i != 0 {
            divisible = false
            break
        }
    }
    
    if divisible {
        break // Eğer tüm sayılara tam olarak bölünebiliyorsa, döngüyü sonlandır.
    }
    
    result += 20 // 20'nin katlarını kontrol ederek devam et.
}

print(result)
*/

//EULAR Project 6.soru

// İlk olarak, fonksiyonlarımızı tanımlayalım:

// İlk n doğal sayının karelerinin toplamını hesaplayan fonksiyon
func sumOfSquares(_ n: Int) -> Int {
    var sum = 0
    // 1'den n'e kadar olan sayıların karelerini topla
    for i in 1...n {
        sum += i * i
    }
    return sum
}

// İlk n doğal sayının toplamının karesini hesaplayan fonksiyon
func squareOfSum(_ n: Int) -> Int {
    // İlk n doğal sayıyı topla
    let sum = (n * (n + 1)) / 2
    // Toplamın karesini döndür
    return sum * sum
}

let sumOfSquaresHundred = sumOfSquares(100)


let squareOfSum1Hundred = squareOfSum(100)

// Son olarak, farkı hesaplayalım:

// İki hesaplama arasındaki farkı bul
let difference = squareOfSum1Hundred - sumOfSquaresHundred

// Sonucu yazdır
print("İlk yüz doğal sayının karelerinin toplamı ile toplamın karesi arasındaki fark: \(difference)")



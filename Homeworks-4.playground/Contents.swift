import Foundation
func login<T: Equatable, U: Equatable>(username: T, password: U, database: [T: U]) -> String {
    if let storedPassword = database[username], storedPassword == password {
        return "Oturum açıldı."
    } else {
        return "Yanlış kullanıcı adı veya şifre."
    }
}

// Örnek kullanım
let usersDatabase = ["user1": "password1", "user2": "password2"]
let userDatabase2 = ["user3": 159753,"user4": 123445555]

print(login(username: "user1", password: "password1", database: usersDatabase)) // Oturum açıldı.
print(login(username: "user1", password: "wrongpassword", database: usersDatabase)) // Yanlış kullanıcı adı veya şifre.
print(login(username: "nonexistinguser", password: "password", database: usersDatabase)) // Yanlış kullanıcı adı veya şifre.
print(login(username: "user3", password: 159753, database: userDatabase2))
print(login(username: "user3", password: 15972322353, database: userDatabase2))





// Sieve of Atkin algoritması kullanarak asal sayıları bulan fonksiyon
func sieveOfAtkin(limit: Int) -> [Int] {
    // Her bir sayının asal olup olmadığını belirlemek için bir dizi oluşturulur
    var sieve = [Bool](repeating: false, count: limit + 1)
    var primes = [Int]() // Asal sayıları tutmak için bir dizi oluşturulur
    
    let sqrtLimit = Int(sqrt(Double(limit))) // Limitin karekökü hesaplanır
    
    // Sieve of Atkin algoritmasının ana adımları gerçekleştirilir
    for x in 1...sqrtLimit {
        for y in 1...sqrtLimit {
            // Bir sayının asal olup olmadığını kontrol etmek için gerekli olan değerler hesaplanır
            //4x^2+y^2 ifadesi için denenir. x ve y değerleri 1 den başlayarak karakök sınırına kadar olan değerler arasında değişir. Her bir x ve y çifti için n değeri hesaplanır. Eğer n, limitin altında ve n mod 12'in 1 veya 5 olması durumunda, sieve dizisindeki ilgili indeks işaretlenir. Bu, n değerinin asal olabileceğini belirtir diğer ifadelerde de sırasıyla 3x^2+y^2 ve 3x^2-y^2 denenir.
            let n = (4 * x * x) + (y * y)
            if n <= limit && (n % 12 == 1 || n % 12 == 5) {
                sieve[n] = !sieve[n] // Asal sayı olarak işaretlenir
            }
            
            let n1 = (3 * x * x) + (y * y)
            if n1 <= limit && n1 % 12 == 7 {
                sieve[n1] = !sieve[n1] // Asal sayı olarak işaretlenir
            }
            
            let n2 = (3 * x * x) - (y * y)
            if x > y && n2 <= limit && n2 % 12 == 11 {
                sieve[n2] = !sieve[n2] // Asal sayı olarak işaretlenir
            }
        }
    }
    //sieve of atkin algoritması en düşük tam karakök değerden düşük sayıları hesaplayamıyor o yüzden kendimiz belirtiyoruz.
    sieve[2] = true
    sieve[3] = true
    
    // Karekökten büyük olan değerlerin asal olup olmadığı kontrol edilir
    for i in 5...sqrtLimit {
        if sieve[i] {
            let iSquare = i * i
            var j = iSquare
            // Asal olmayan değerler false olarak işaretlenir
            while j <= limit {
                sieve[j] = false
                j += iSquare
            }
        }
    }
    
    // Asal olan değerler primes dizisine eklenir
    for i in 2...limit {
        if sieve[i] {
            primes.append(i)
        }
    }
    
    return primes // Asal sayıları içeren dizi döndürülür
}

// Belirli bir sıradaki asal sayıyı bulan fonksiyon
func nthPrime(_ n: Int) -> Int {
    guard n > 0 else { return 0 }
    // Limit hesaplanır (n log(n) + log(log(n)))
    let limit = n * (Int(log(Double(n))) + Int(log(log(Double(n)))))
    // Sieve of Atkin algoritması kullanılarak asal sayılar bulunur
    let primes = sieveOfAtkin(limit: limit)
    // İstenen sıradaki asal sayı döndürülür
    return primes[n - 1]
}

//Alttaki kodların buradaki işlemleri beklememesi için async olarak çalıştırdım.
DispatchQueue.main.async {
    let result = nthPrime(10001)
    print("The 10001st prime number is \(result)")
}
/*let result = nthPrime(10001)
print("The 10001st prime number is \(result)")
*/

//MARK: EXERCİSM
//Artık yıl hesaplama
func isLeapYear(_ year: Int) -> Bool {

if year % 4 == 0 {
    if year % 100 == 0 {
        if year % 400 == 0 {
            return true
        } else {
            return false
        }
    } else {
        return true
    }
} else {
    return false
}
}
print(isLeapYear(1983))
//----------------------------
func toLimit(_ limit: Int, inMultiples: [Int]) -> Int {
    
    if inMultiples.isEmpty {
        return 0
    }

    var multiples = Set<Int>()

    // Verilen limit sınırına kadar olan sayıları oluştur
    for i in 1..<limit {
        // Her çarpan için, sınırı geçmeyecek şekilde çarpımı ekle
        for factor in inMultiples {
            if factor != 0 && i % factor == 0 {
                multiples.insert(i)
                break
            }
        }
    }

    // Toplamı hesapla
    return multiples.reduce(0, +)
}
//---------------------------------------------------
func reverseString(_ input: String) -> String {
    var reversedString = ""
    
    // Iterate over the characters of the input string in reverse order
    for char in input.reversed() {
        // Append each character to the reversedString
        reversedString.append(char)
    }
    
    return reversedString
}
let nString = "stressed"
let rString = reverseString(nString)
print(rString)


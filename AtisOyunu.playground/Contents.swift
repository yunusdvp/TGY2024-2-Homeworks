import Foundation

class Player {
    var nickname: String
    var score: Int
    
    init(nickname: String) {
        self.nickname = nickname
        self.score = 0
    }
    
    func displayScore() {
        print("\(nickname)'in puanı: \(score)")
    }
}

class Launcher {
    var theta: Double
    var V: Double
    
    init() {
        self.theta = 0
        self.V = 0
    }
    
    func calculateRange() -> Double {
        let g = 10.0  // yerçekimi
        return (V * V) * sin(2 * theta * Double.pi / 180) / g
    }
}

class Bottle {
    var d: Double
    var delta: Double
    var status: Bool  // 0: devrik, 1: dik
    
    init(d: Double, delta: Double) {
        self.d = d
        self.delta = delta
        self.status = false
    }
    
    func evaluateStatus(range: Double) {
        if (d - delta) <= range && range <= (d + delta) {
            status = false  // devrik durumda
        } else {
            status = true  // dik durumda
        }
    }
}

class Game {
    var player: Player?
    var launcher: Launcher
    var bottle: Bottle?
    
    init() {
        self.launcher = Launcher()
    }
    
    func setPlayer(nickname: String) {
        player = Player(nickname: nickname)
    }
    
    func setBottlePosition(d: Double, delta: Double) {
        bottle = Bottle(d: d, delta: delta)
    }
    
    func setLaunchParameters(theta: Double, V: Double) -> Bool {
        guard (0...90).contains(theta) else {
            print("Hatalı değer: Açı, 0 ile 90 derece arasında olmalıdır.")
            return false
        }
        guard (0...100).contains(V) else {
            print("Hatalı değer: Hız, 0 ile 100 m/s arasında olmalıdır.")
            return false
        }
        launcher.theta = theta
        launcher.V = V
        return true
    }
    
    func launch() {
        guard let bottle = bottle else {
            print("Hata: Şişe belirlenmemiş!")
            return
        }
        
        let range = launcher.calculateRange()
        bottle.evaluateStatus(range: range)
        if bottle.status == false {
            player?.score += 1
            print("Şişe devrildi!")
        } else {
            print("Şişeyi kaçırdınız!")
        }
        player?.displayScore()
    }
}

// Örnek kullanım
let game = Game()
game.setPlayer(nickname: "Oyuncu1")
game.setBottlePosition(d: 200, delta: 0.5)


if game.setLaunchParameters(theta: 45, V: 50) {
    game.launch()
}


if game.setLaunchParameters(theta: 60, V: 100) {
    game.launch()
}

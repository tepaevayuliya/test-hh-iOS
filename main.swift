class Creature {
    var attack: Int
    var protection: Int
    var initialHealth: Int
    var health: Int
    var damage: Int

    init(N: Int, M: Int, L: Int) {
        if L < 1 {
            print("Параметр L меньше 1")
            fatalError("Неправильные параметры")
        }
        if N > M {
            print("Параметр M должен быть больше N")
            fatalError("Неправильные параметры")
        }

        attack = Int.random(in: 1 ... 30)
        protection = .random(in: 1 ... 30)
        initialHealth = Int.random(in: 1 ... L)
        health = initialHealth
        damage = .random(in: N ... M)
    }

    func attack(creature: Creature) -> Int {
        var modifier = attack - creature.protection + 1
        if modifier < 1 {
            modifier = 1
        }

        var isSuccess = false
        for _ in 1...modifier where (Int.random(in: 1 ... 6)) > 4 {
            isSuccess = true
            break
        }

        if isSuccess {
            let damageDone = Int.random(in: 1 ... creature.attack)
            return damageDone
        } else {
            return 0
        }
    }
}

class Player: Creature {
    var countHealving = 4

    func healing() {
        if countHealving > 0 {
            let healing = Int(0.3 * Double(game.player.initialHealth))
            game.player.health = max(game.player.health + healing, game.player.initialHealth)
            print("Здоровье игрока после исцеления: \(game.player.health)")
            countHealving -= 1
        } else {
            print("Исцеление недоступно")
        }
    }
}

class Monster: Creature {
}

class Game {
    let player: Player
    let monsters: [Monster]

    init(player: Player, monsters: [Monster]) {
        self.player = player
        self.monsters = monsters
    }

    func playerAttack(monsterIndex: Int) {
        if (monsterIndex > monsters.count - 1) || (monsterIndex < 0) {
            print("Ошибка. Монстра не существует")
            return
        } else if monsters[monsterIndex].health == 0 {
            print("Ошибка. Монстр уже мертв")
            return
        }

        let damageDone = player.attack(creature: monsters[monsterIndex])
        print("Атака игрока: \(damageDone)")
        if damageDone >= monsters[monsterIndex].health {
            monsters[monsterIndex].health = 0
            print("Монстр убит")
        } else {
            monsters[monsterIndex].health -= damageDone
            print("Здоровье монстра после удара: \(monsters[monsterIndex].health)")
        }
    }

    func monsterAttack(monsterIndex: Int) {
        if (monsterIndex > monsters.count - 1) || (monsterIndex < 0) {
            print("Ошибка. Монстра не существует")
            return
        } else if monsters[monsterIndex].health == 0 {
            print("Ошибка. Монстр уже мертв и не может атаковать")
            return
        } else if player.health == 0 {
            print("Ошибка. Игрок мертв")
            return
        }
        let damageDone = monsters[monsterIndex].attack(creature: player)
        print("Атака монстра: \(damageDone)")
        if damageDone >= player.health {
            player.health = 0
            print("Здоровье игрока: 0")
        } else {
            player.health -= damageDone
            print("Здоровье игрока после удара: \(player.health)")
        }
    }
}

let game = Game(player: .init(N: 10, M: 12, L: 50), monsters: [ .init(N: 5, M: 10, L: 10), .init(N: 3, M: 7, L: 20)])

game.monsterAttack(monsterIndex: 1)
game.player.healing()
game.player.healing()
game.playerAttack(monsterIndex: 1)
game.playerAttack(monsterIndex: 3) // Ошибка. Монстра не существует
game.player.healing()
game.player.healing()
game.player.healing() // Исцеление недоступно
game.player.healing() // Исцеление недоступно

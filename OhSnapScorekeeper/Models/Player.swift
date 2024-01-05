import Foundation

struct Player {
    let id = UUID()
    let name: String
    let position: Int
    var rounds: [Round] = []
    
    var totalScore: Int {
        let pointsEarned = rounds.map({ $0.actualScore ?? 0 }).reduce(0, +)
        let bonuses = rounds.filter { $0.bonus == true }.count * 10
        return pointsEarned + bonuses
    }
}

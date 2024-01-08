import Foundation

struct Player: Identifiable, Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.position > rhs.position
    }
    
    let id = UUID()
    var name: String
    var position: Int
    var rounds: [Round] = []
    
    var totalScore: Int {
        let pointsEarned = rounds.map({ $0.actualScore ?? 0 }).reduce(0, +)
        let bonuses = rounds.filter { $0.bonus == true }.count * 10
        return pointsEarned + bonuses
    }
}

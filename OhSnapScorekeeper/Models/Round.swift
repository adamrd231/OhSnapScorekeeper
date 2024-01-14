import Foundation

struct Round {
    let id = UUID()
    var predictedScore: Int?
    var actualScore: Int?
    
    init(predictedScore: Int? = nil, actualScore: Int? = nil) {
        self.predictedScore = predictedScore
        self.actualScore = actualScore
    }
    
    var bonus: Bool {
        guard predictedScore != nil else { return false }
        guard actualScore != nil else { return false }
        if predictedScore == actualScore {
            return true
        } else {
            return false
        }
    }
}

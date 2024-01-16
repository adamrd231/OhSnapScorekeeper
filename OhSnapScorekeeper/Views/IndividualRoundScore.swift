import SwiftUI

struct IndividualRoundScore: View {
    let score: Int?
    
    init(_ score: Int? = nil) {
        self.score = score
    }
    
    var body: some View {
        if let scoreAvailable = score {
            Text(scoreAvailable, format: .number)
        } else {
            Text("-")
        }
    }
}

struct IndividualRoundScore_Previews: PreviewProvider {
    static var previews: some View {
        IndividualRoundScore(3)
    }
}

import SwiftUI

struct ScorecardView: View {
    @ObservedObject var gameVM: GameViewModel
    @Binding var currentScreen: Int
    @State var currentGuess: Int? = nil
    @State var isGameOver: Bool = false
    var body: some View {
        VStack {
            Button("All done!") { currentScreen = 0 }
            Text("Current Round: \(gameVM.calculatedRoundArray[gameVM.currentRound])")
                .font(.title)
            HStack(alignment: .top) {
                HStack(alignment: .top, spacing: 30) {
                    ForEach(gameVM.players, id: \.id) { player in
                        VStack(spacing: 10) {
                            Text(player.name)
                                .bold()
                            VStack(spacing: 5) {
                                ForEach(Array(zip(gameVM.calculatedRoundArray.indices, gameVM.calculatedRoundArray)), id: \.0) { index, item in
                                    HStack {
                                        if player.name == "Round" {
                                            Text("\(item)")
                                        }
                                        if player.name != "Round" {
                                            // Get first guess and actual round
                                            if index >= player.rounds.startIndex && index < player.rounds.count {
                                                if let predictedScore = player.rounds[index].predictedScore {
                                                    Text(predictedScore, format: .number)
                                                } else {
                                                    Text("X")
                                                }
                                                Text("|")
                                                if let actualScore = player.rounds[index].actualScore {
                                                    Text(actualScore, format: .number)
                                                    
                                                } else {
                                                    Text("X")
                                                }
                                            } else {
                                                HStack {
                                                    Text("X")
                                                    Text("|")
                                                    Text("X")
                                                }
                                            }
                                        }
                                    }
                  
                                }
                            }
                            
                            if player.name != "Round" {
                                VStack {
                                    Text("Total")
                                        .bold()
                                    Text(player.totalScore, format: .number)
                                }
                            }
                           
                        }
                    }
                }
            }
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(15)

            // Entering input section
            // 1 enter predictions for all players
            // What is the flag for changing from entering prediction to actual?
            // 2 play round
            // 3 enter actual scores for all players
            // 4 end round and start new round
            gameVM.pl
            if gameVM.players.count > 0 {
                Button(gameVM.gameState == .enteringGuesses ? "Enter guess for \(gameVM.players[gameVM.currentPosition].name)" : "Enter score for \(gameVM.players[gameVM.currentPosition].name)") {
                    // Check if current position has a round for players
                    print("test")
                    if gameVM.gameState == .enteringGuesses {
                        // enter numbers for predictions until players are done guessing
                        var newRound = Round(predictedScore: currentGuess)
                        ayers[gameVM.currentPosition].rounds.append(newRound)
                        currentGuess = nil
                        
                        if gameVM.currentPosition + 1 >= gameVM.players.count {
                            gameVM.currentPosition = 1
                        } else {
                            gameVM.currentPosition += 1
                        }
                    } else {
                        // Entering actual numbers
                        gameVM.players[gameVM.currentPosition].rounds[gameVM.currentRound].actualScore = currentGuess
                        currentGuess = nil
                        if gameVM.currentPosition + 1 >= gameVM.players.count {
                            gameVM.currentPosition = 1
                            // check if game is over
                            if gameVM.currentRound + 1 >= gameVM.calculatedRoundArray.count {
                                // Game Over
                                isGameOver = true
                            } else {
                                gameVM.currentRound += 1
                            }
                            
                        } else {
                            gameVM.currentPosition += 1
                        }
                    }
                }
                .buttonStyle(.bordered)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.gray, lineWidth: 5)

                    TextField(gameVM.gameState == .enteringGuesses ? "Guess" : "Score", value: $currentGuess, formatter: NumberFormatter())
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.gray)
                        .font(.title)
                        .fontWeight(.heavy)
      
                }
                .fixedSize()
            }
        }
    }
}

struct ScorecardView_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardView(
            gameVM: dev.gameVM,
            currentScreen: .constant(2)

        )
        .preferredColorScheme(.light)
    }
}

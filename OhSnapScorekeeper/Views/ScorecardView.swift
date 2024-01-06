import SwiftUI

struct ScorecardView: View {
    @ObservedObject var gameVM: GameViewModel
    @Binding var currentScreen: Int
    @State var currentGuess: Int = 0
    @State var isGameOver: Bool = false
    var body: some View {
        VStack {
            HStack {
                Button("All done") { currentScreen = 0 }
                Spacer()
            }
            .padding(.horizontal)
           Spacer()
            Text("Oh Snap!")
                .font(.title)
                .bold()

            // Table for showing scorecard
            HStack(alignment: .top, spacing: 30) {
                ForEach(gameVM.players, id: \.id) { player in
                    VStack(spacing: 10) {
                        // Player
                        Text(player.name)
                            .bold()
                            // Zip round array with indices for access to arrays
                            ForEach(Array(zip(gameVM.calculatedRoundArray.indices, gameVM.calculatedRoundArray)), id: \.0) { index, item in
                                //
                                HStack {
                                    if player.name == "Round" {
                                        Text("\(item)")
                                    }
                                    if player.name != "Round" {
                                        // Get first guess and actual round
                                        if index >= player.rounds.startIndex && index < player.rounds.count {
                                            if let predictedScore = player.rounds[index].predictedScore {
                                                Text(predictedScore, format: .number)
                                            }
                                            Text("|")
                                            if let actualScore = player.rounds[index].actualScore {
                                                Text(actualScore, format: .number)
                                                
                                            } else {
                                                Text("_")
                                            }
                                        } else {
                                            Text("_")
               
                                            
                                        }
                                    }
                                }
                                .font(gameVM.currentRound == index ? .title2 : .body)
                                .opacity(gameVM.currentRound == index ? 1.0 : 0.8)
                            }
                            if player.name != "Round" {
                                VStack {
                                    Text("Total")
                                        .bold()
                                    Text(player.totalScore, format: .number)
                                }
                                .padding(.top)
                            }
                    }
                }
            }
            
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(15)

            if gameVM.players.count > 0 {
                Text("Current Round: \(gameVM.calculatedRoundArray[gameVM.currentRound])")
                Text(gameVM.gameState == .enteringGuesses ? "Enter guess for \(gameVM.players[gameVM.currentPosition].name)" : "Enter score for \(gameVM.players[gameVM.currentPosition].name)")
                    .bold()

                HStack {
                    ForEach(0...gameVM.calculatedRoundArray[gameVM.currentRound], id: \.self) { number in
                        Button {
                            if gameVM.gameState == .enteringGuesses {
                                // enter numbers for predictions until players are done guessing
                                var newRound = Round(predictedScore: number)
                                gameVM.players[gameVM.currentPosition].rounds.append(newRound)
                                
                                if gameVM.currentPosition + 1 >= gameVM.players.count {
                                    gameVM.currentPosition = 1
                                } else {
                                    gameVM.currentPosition += 1
                                }
                            } else {
                                // Entering actual numbers
                                gameVM.players[gameVM.currentPosition].rounds[gameVM.currentRound].actualScore = number
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
                        } label: {
                            Text(number, format: .number)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                Spacer()
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

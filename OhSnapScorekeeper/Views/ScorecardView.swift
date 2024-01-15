import SwiftUI

struct ScorecardView: View {
    @ObservedObject var gameVM: GameViewModel
    @Binding var currentScreen: Screens

    var body: some View {
        NavigationStack {
            VStack {
                // Table for showing scorecard
                ScorecardTableView(
                    players: gameVM.players,
                    calculatedRoundArray: gameVM.calculatedRoundArray,
                    currentRound: gameVM.currentRound,
                    currentPosition: gameVM.currentPosition
                )
                .frame(height: UIScreen.main.bounds.height * 0.66)
                .background(.gray.opacity(0.1))
                .onChange(of: gameVM.isGameRunning, perform: { isGameRunning in
                    UIApplication.shared.isIdleTimerDisabled = isGameRunning
                })
                VStack {
                    Spacer()
                    Text("Round: \(gameVM.calculatedRoundArray[gameVM.currentRound])")
                        .font(.title2)
                    Text(gameVM.gameState == .enteringGuesses ? "Enter guess for \(gameVM.players[gameVM.currentPosition].name)" : "Enter score for \(gameVM.players[gameVM.currentPosition].name)")
                        .bold()
                    HStack {
                        ForEach(0...gameVM.calculatedRoundArray[gameVM.currentRound], id: \.self) { number in
                            Button {
                                if gameVM.gameState == .enteringGuesses {
                                    gameVM.enterGuess(number)
                                } else {
                                    gameVM.enterActual(number)
                                }
         
                            } label: {
                                Text(number, format: .number)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    Button {
                        gameVM.rewindGame()
                    } label: {
                        HStack {
                            Image(systemName: "backward")
                            Text("Rewind")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
            }
            .navigationTitle("Oh Snap!")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("All done") {
                        gameVM.resetGame()
                        currentScreen = .home
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset scores") {
                        gameVM.resetGame()
                    }
                }
            }
        }
    }
}

struct ScorecardView_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardView(
            gameVM: dev.gameVM,
            currentScreen: .constant(.scorecardView)

        )
    }
}

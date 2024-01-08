import SwiftUI

struct ScorecardView: View {
    @ObservedObject var gameVM: GameViewModel
    @Binding var currentScreen: Screens
    @State var currentGuess: Int = 0

    var body: some View {
        VStack {
            // Table for showing scorecard
            ScorecardTableView(gameVM: gameVM)

            if gameVM.players.count > 0 {
                Text("Current Round: \(gameVM.calculatedRoundArray[gameVM.currentRound])")
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

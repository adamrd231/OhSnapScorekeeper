import SwiftUI

struct LaunchView: View {
    @Binding var currentScreen: Int
    
    var body: some View {
        VStack {
            // Setup game screen
            Text("Oh Snap Scorekeeper").font(.title)
            Button("Start Game") {
                currentScreen = 1
            }
            // Play game (one person)
            // Play game with friends (everyone fills out their own numbers)
        }
    }
}

struct HomeView: View {
    @StateObject var gameVM = GameViewModel()
    @State var currentScreen = 0
    
    var body: some View {
        if currentScreen == 0 {
            LaunchView(currentScreen: $currentScreen)
        } else if currentScreen == 1 {
            AddPlayersView(
                currentScreen: $currentScreen,
                gameVM: gameVM
            )
        } else if currentScreen == 2 {
            ScorecardView(
                currentScreen: $currentScreen,
                gameVM: gameVM
            )
  
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

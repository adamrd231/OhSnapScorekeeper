import SwiftUI

enum Screens: Int {
    case home = 0
    case updatePlayers = 1
    case scorecardView = 2
}

struct LaunchView: View {
    @Binding var currentScreen: Screens
    
    var body: some View {
        ZStack {
            ZStack {
                Image("cards")
                    .resizable()
                    .scaledToFill()
                Rectangle()
                    .opacity(0.8)
            }
            .edgesIgnoringSafeArea(.all)
                
            
            VStack {
                // Setup game screen
                Text("Oh Snap Scorekeeper")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Button("Setup game scorecard") {
                    currentScreen = .updatePlayers
                }
                .buttonStyle(.borderedProminent)
                // Play game (one person)
                // Play game with friends (everyone fills out their own numbers)
            }
          
        }
       
    }
}

struct HomeView: View {
    @StateObject var gameVM = GameViewModel()
    @State var currentScreen: Screens = .home
    
    var body: some View {
        if currentScreen == .home {
            LaunchView(currentScreen: $currentScreen)
        } else if currentScreen == .updatePlayers {
            AddPlayersView(
                currentScreen: $currentScreen,
                gameVM: gameVM
            )
        } else if currentScreen == .scorecardView {
            ScorecardView(
                gameVM: gameVM,
                currentScreen: $currentScreen
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//
//  PlayerNameView.swift
//  OhSnapScorekeeper
//
//  Created by Adam Reed on 1/15/24.
//

import SwiftUI

struct PlayerNameView: View {
    let playerName: String
    let isSelected: Bool
    var body: some View {
        Text(playerName)
            .frame(minWidth: 0, maxWidth: .infinity)
            .font(.caption2)
            .foregroundColor(isSelected ? .blue : .black)
            .fontWeight(isSelected ? .bold : .regular)
    }
}

struct PlayerNameView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerNameView(playerName: "Adam", isSelected: true)
    }
}

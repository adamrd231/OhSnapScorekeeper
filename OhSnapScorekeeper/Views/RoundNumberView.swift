//
//  RoundNumberView.swift
//  OhSnapScorekeeper
//
//  Created by Adam Reed on 1/15/24.
//

import SwiftUI

struct RoundNumberView: View {
    let roundNumber: Int
    let isSelected: Bool
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(isSelected ? Color.blue : Color(.darkGray))
            
            Text(roundNumber, format: .number)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(width: 15)
        .frame(minHeight: 50)
    }
}

struct RoundNumberView_Previews: PreviewProvider {
    static var previews: some View {
        RoundNumberView(roundNumber: 3, isSelected: false)
    }
}

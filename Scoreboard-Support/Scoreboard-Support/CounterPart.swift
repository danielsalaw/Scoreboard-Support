//
//  CounterPart.swift
//  Scoreboard
//
//  Created by Daniel on 04.07.20.
//  Copyright © 2020 Daniel Salaw. All rights reserved.
//

import SwiftUI

struct CounterPart: View {
    @State var scoreLeft: Int = 0
    @State var teamName: [String] = ["blue", "red", "green", "yellow"]
    @State var swipeOffsetX: Double = 0.0
    
    //Auswahl durchloopen
    @State var selectedLeftTeam: Int = 0 {
        didSet {
            if selectedLeftTeam < 0 {
                selectedLeftTeam = teamName.count-1
            } else if selectedLeftTeam > teamName.count-1 {
                selectedLeftTeam = 0
            }
        }
    }
    @State var selectedLeftTeamColor: Color = Color(#colorLiteral(red: 0, green: 0.2235294118, blue: 0.9215686275, alpha: 1))

    
    
    var body: some View {
        ZStack {
            //BG Color
            Color.init("BGColor").edgesIgnoringSafeArea(.all)
            
            HStack {
                VStack {
                    Klappkarte(countValue: scoreLeft, teamColor: selectedLeftTeamColor)
                    
                    //Swipe um Team zu wechseln
                    HStack(spacing: 5) {
                            Image(systemName: "arrowtriangle.left.fill")
                                .font(Font.system(size: 12 ,weight: .regular))
                            Text(teamName[selectedLeftTeam])
                                .font(Font.system(size: 24 ,weight: .bold, design: .monospaced).smallCaps())
                            Image(systemName: "arrowtriangle.right.fill")
                                .font(Font.system(size: 12 ,weight: .regular))
                        }
                        .foregroundColor(Color("primaryColor")).opacity(0.2)
                    .gesture(
                            DragGesture()
                        .onChanged({
                            action in
                            self.swipeOffsetX = Double(action.translation.width * 0.75)
                        })
                        
                        .onEnded({
                            action in
                            
                            print("👆🏻 swipeOffsetX: \(self.swipeOffsetX)")
                            
                            let left = self.swipeOffsetX < 30
                            let right = self.swipeOffsetX > 30
                            
                            if left { self.selectedLeftTeam += 1 }
                            if right { self.selectedLeftTeam -= 1 }
                            
                            
                            // Farbe wechseln
                            
                            if self.selectedLeftTeam == 0 {
                                self.selectedLeftTeamColor = Color(#colorLiteral(red: 0, green: 0.2235294118, blue: 0.9215686275, alpha: 1))
                                print("Teamcolor: 🟦 \n\(self.selectedLeftTeamColor)")
                            } else if self.selectedLeftTeam == 1 {
                                self.selectedLeftTeamColor = Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                                print("Teamcolor: 🟥 \n\(self.selectedLeftTeamColor)")
                            } else if self.selectedLeftTeam == 2  {
                                self.selectedLeftTeamColor = Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
                                print("Teamcolor: 🟩 \n\(self.selectedLeftTeamColor)")
                            } else {
                                self.selectedLeftTeamColor = Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
                                print("Teamcolor: 🟨 \n\(self.selectedLeftTeamColor)")
                            }
                            
                            self.swipeOffsetX = 0 // reset
                        })
                        )

                }
            }
        }
    }
}

struct CounterPart_Previews: PreviewProvider {
    static var previews: some View {
        CounterPart()
    }
}


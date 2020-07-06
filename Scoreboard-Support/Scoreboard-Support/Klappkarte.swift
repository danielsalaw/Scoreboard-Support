//
//  Klappkarte.swift
//  Scoreboard
//
//  Basierend auf Martins Klappkarte
//
//

import SwiftUI
struct Klappkarte: View {
    
    
    @State var countValue: Int = 0{
        didSet {
            if countValue < 0 {
                countValue = 0
            }
        }
    }
    @State var flipTrigger: Bool = false
    @State var flipTriggerTop: Bool = false
    @State var swipeOffsetY: Double = 0.0
    @State var opacityBackgroundCard: Double = 0.0
    
    @State var teamColor: Color = Color(#colorLiteral(red: 0, green: 0.2235294118, blue: 0.9215686275, alpha: 1))
    
    
    @State var zPosition: Double = 0
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // 🃏🔼 Karte oben
            ZStack {
                BaseCardView(upperHalf: true, displayedNumber: countValue + 1, tileColor: teamColor)
                    .opacity(opacityBackgroundCard)
                    .rotation3DEffect(Angle(degrees: min(max(-swipeOffsetY * 0.65 + 40, 0), 10.0)),
                                      axis: (x: 1.0, y: 0.0, z: 0.0),
                                      anchor: .bottom,
                                      perspective: 0.7)
                
                ForgroundTopCardView(upperHalf: true, displayedNumber: flipTriggerTop ? countValue + 1 : countValue, tileColor: teamColor, backsideVisible: flipTriggerTop ? true : false, offsetY: $swipeOffsetY)
            }.zIndex(0)
                
                // Count on Tap up
//                .onTapGesture {
//
//                    self.swipeOffsetY = Double(-90)
//                    withAnimation(.easeInOut(duration: 0.3)) {
//                        self.swipeOffsetY = Double(30)
//                        self.opacityBackgroundCard = 0.9099999999999999
//                    }
//                    self.flipTriggerTop = true
//                    self.zPosition = -20
//                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0)) {
//                        self.swipeOffsetY = Double(-179)
//                        self.opacityBackgroundCard = 1.2
//                    }
//
//                    withAnimation(.none) {
//
//                        self.countValue += 1
//                        self.swipeOffsetY = 0.0 // reset
//                        self.flipTrigger = false
//                        self.flipTriggerTop = false
//                        self.zPosition = 0
//                    }
//            }
//            .animation(
//                Animation
//                    .spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0)
//            )

            
            
            
            // 🃏🔽 Karte unten
            ZStack {
                BaseCardView(upperHalf: false, displayedNumber: {countValue <= 0 ? countValue : countValue - 1}(), tileColor: teamColor)
                    .opacity(opacityBackgroundCard)
                    .rotation3DEffect(Angle(degrees: min(max(-10, -swipeOffsetY * 0.65 - 40), 0)),
                                      axis: (x: 1.0, y: 0.0, z: 0.0),
                                      anchor: .top,
                                      perspective: 0.7)
                
                ForgroundBottomCardView(upperHalf: false, displayedNumber: flipTrigger ? {countValue <= 0 ? countValue : countValue - 1}() : countValue, tileColor: teamColor, backsideVisible: flipTrigger ? true : false, offsetY: $swipeOffsetY)
            }.zIndex(zPosition)
                
                // Count on Tap down
//                .onTapGesture {
//
//                    withAnimation(.easeInOut(duration: 1.3)) {
//                        self.swipeOffsetY = Double(-90)
//                        self.opacityBackgroundCard = 0.9099999999999999
//                    }
//                    self.flipTriggerTop = false
//                    self.zPosition = -20
//                    withAnimation(.spring(response: 1.3, dampingFraction: 0.6, blendDuration: 0)) {
//                        self.swipeOffsetY = Double(-179)
//                        self.opacityBackgroundCard = 1.2
//                    }
//
//                    withAnimation(.none) {
//                        self.countValue -= 1
//                        self.swipeOffsetY = 0.0 // reset
//                        self.flipTrigger = false
//                        self.flipTriggerTop = false
//                        self.zPosition = 0
//                    }
//            }
//            .animation(
//                Animation
//                    .spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0)
//            )

        }.gesture(
            
            DragGesture()
                .onChanged({
                    action in
                    
                    // 0️⃣ prevent counting below 0
                    if self.countValue == 0 && action.translation.height < -60 {
                        self.swipeOffsetY = 0
                    } else {
                        self.swipeOffsetY = Double(action.translation.height * 0.75)
                    }
                    
                    if self.swipeOffsetY < -90 {
                        
                        // von unten nach oben 👆🏻
                        self.flipTrigger = true
                        self.zPosition = 0
                        
                    } else if self.swipeOffsetY > 90 {
                        
                        // von oben nach unten 👇🏻
                        self.flipTriggerTop = true
                        
                    }else {
                        
                        // Reset
                        self.flipTrigger = false
                        self.flipTriggerTop = false
                        self.zPosition = -1
                    }
                    
                    
                    // 🕶 Opacity
                    // scale 50 - 100
                    if self.swipeOffsetY > 0 {
                        self.opacityBackgroundCard = { self.swipeOffsetY * 0.001 + 0.82 }()
                    } else {
                        // negativen Wert in Positiven umwandeln
                        let positiveSwipeOffsetY = abs(self.swipeOffsetY)
                        self.opacityBackgroundCard = { positiveSwipeOffsetY * 0.001 + 0.82 }()
                    }
                    
                    print("\nSwipeOffsetY: \(self.swipeOffsetY) \nFlipTrigger 🔼: \(self.flipTriggerTop) \nFlipTrigger 🔽: \(self.flipTrigger) \nOpacity: \(self.opacityBackgroundCard) \nzPostion: \(self.zPosition)")
                    
                })
                .onEnded({
                    action in
                    let up = self.swipeOffsetY > 90.0
                    let down = self.swipeOffsetY < -90.0
                    
                    if up { self.countValue += 1 }
                    if down { self.countValue -= 1 }
                    
                    self.swipeOffsetY = 0.0 // reset
                    self.flipTrigger = false
                    self.flipTriggerTop = false
                    
                    
                })
        )

    }
}

struct BaseCardView: View {
    var upperHalf: Bool
    var displayedNumber: Int
    var tileColor: Color
    var backsideVisible: Bool = false
    
    var body: some View {
        // 🃏 Basiskarte Oben
        ZStack(alignment: upperHalf ? .top : .bottom) {
            
            //leerer Container für die Lücke
            Rectangle()
                .foregroundColor(.black).opacity(0)
                .frame(width: 131, height: 67)
            
            // 🃏 Karte mit Zahl
            ZStack {
                // 🃏 Kartenhälfte
                Rectangle()
                    .foregroundColor(tileColor)
                
                // 🃏 Zahl
                Text(String(displayedNumber))
                    .font(Font.system(size: 90 ,weight: .semibold, design: .monospaced))
                    .foregroundColor(Color("primaryColor"))
                    .padding(.top, upperHalf ? 67 : -67)
            }
            .frame(width: 131, height: 66)
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
        }
    }
}

struct  ForgroundBottomCardView: View {
    var upperHalf: Bool
    var displayedNumber: Int
    var tileColor: Color
    var backsideVisible: Bool = false
    @Binding var offsetY: Double
    
    var body: some View {
        // 🃏 Basiskarte Oben
        ZStack(alignment: upperHalf ? .top : .bottom) {
            
            //leerer Container für die Lücke
            Rectangle()
                .foregroundColor(.black).opacity(0)
                .frame(width: 131, height: 67)
            
            // 🃏 Karte mit Zahl
            ZStack {
                // 🃏 Kartenhälfte
                Rectangle()
                    .foregroundColor(tileColor)
                
                // 🃏 Zahl
                Text(String(displayedNumber))
                    .font(Font.system(size: 90 ,weight: .semibold, design: .monospaced))
                    .foregroundColor(Color("primaryColor"))
                    .padding(.top, backsideVisible ? 67 : -67)
                    .rotationEffect(.degrees(backsideVisible ? 180 : 0))
                    .rotation3DEffect(.degrees(backsideVisible ? 180 : 0), axis: (x: 0, y: backsideVisible ? 1 : 0, z: 0))
            }
            .frame(width: 131, height: 66)
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
            .animation(.none)
        }
        .rotation3DEffect(Angle(degrees: min(max(0.0, -offsetY), 179.0)),
                          axis: (x: 1.0, y: 0.0, z: 0.0),
                          anchor: .top,
                          perspective: 0.7)
        
    }
}



struct  ForgroundTopCardView: View {
    var upperHalf: Bool
    var displayedNumber: Int
    var tileColor: Color
    var backsideVisible: Bool = false
    @Binding var offsetY: Double
    
    var body: some View {
        // 🃏 Basiskarte Oben
        ZStack(alignment: upperHalf ? .top : .bottom) {
            
            //leerer Container für die Lücke
            Rectangle()
                .foregroundColor(.black).opacity(0)
                .frame(width: 131, height: 67)
            
            // 🃏 Karte mit Zahl
            ZStack {
                // 🃏 Kartenhälfte
                Rectangle()
                    .foregroundColor(tileColor)
                
                // 🃏 Zahl
                Text(String(displayedNumber))
                    .font(Font.system(size: 90 ,weight: .semibold, design: .monospaced))
                    .foregroundColor(Color("primaryColor"))
                    .padding(.bottom, backsideVisible ? 67 : -67)
                    .rotationEffect(.degrees(backsideVisible ? 180 : 0))
                    .rotation3DEffect(.degrees(backsideVisible ? 180 : 0), axis: (x: 0, y: backsideVisible ? 1 : 0, z: 0))
            }
            .frame(width: 131, height: 66)
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
            .animation(.none)
        }
        .rotation3DEffect(Angle(degrees: min(max(-offsetY, -179), 0.0)),
                          axis: (x: 1.0, y: 0.0, z: 0.0),
                          anchor: .bottom,
                          perspective: 0.7)
        
    }
}



//MARK: - Preview

struct Klappkarte_Previews: PreviewProvider {
    static var previews: some View {
        Klappkarte()
    }
}

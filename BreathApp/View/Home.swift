//
//  Home.swift
//  BreathApp
//
//  Created by Akhilgov Magomed Abdulmazhitovich on 28.07.2022.
//

import SwiftUI

struct Home: View {
    
    @Namespace var animation
    
    @State var currentType: BreatheType = sampleTypes[0]
    
    @State var showBreathView: Bool = false
    @State var startAnimation: Bool = false
    
    @State var timerCount: CGFloat = 0
    @State var breatheAction = "Breath In"
    @State var count: Int = 0
    
    
    
    var body: some View {
        ZStack {
            background
            content
            Text(breatheAction)
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 50)
                .opacity(showBreathView ? 1 : 0)
                .animation(.easeInOut(duration: 1), value: breatheAction)
                .animation(.easeInOut(duration: 1), value: showBreathView)
        }
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            if showBreathView {
                if timerCount >= 3.2 {
                    timerCount = 0
                    breatheAction = (breatheAction == "Breathe Out" ? "Breathe In" : "Breathe Out")
                    withAnimation(.easeInOut(duration: 3).delay(0.1)) {
                        startAnimation.toggle()
                    }
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                } else {
                    timerCount += 0.01
                }
                count = 3 - Int(timerCount)
            } else {
                timerCount = 0
            }
        }
    }
    @ViewBuilder
    private var content: some View {
        VStack {
            HStack {
                Text("Breathe")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(
                    action: {},
                    label: {
                        Image(systemName: "suit.heart")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 42, height: 42, alignment: .center)
                            .background {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.ultraThinMaterial)
                            }
                    }
                )
            }
            .padding()
            .opacity(showBreathView ? 0 : 1)
            
            GeometryReader { proxy in
                let size = proxy.size
                VStack {
                    breatheView(size: size)
                    
                    Text("Breathe to reduce")
                        .font(.title3)
                        .foregroundColor(.white)
                        .opacity(showBreathView ? 0 : 1)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(sampleTypes) { type in
                                Text(type.title)
                                    .foregroundColor(currentType.id == type.id ? .black : .white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 15)
                                    .background {
                                        if currentType.id == type.id {
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(Color.white)
                                                .matchedGeometryEffect(id: "TAB", in: animation)
                                        } else {
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .stroke(.white.opacity(0.5))
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            currentType = type
                                        }
                                    }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .opacity(showBreathView ? 0 : 1)
                    
                    Button(
                        action: { startBreathing() },
                        label: {
                            Text(showBreathView ? "FINISH" : "START")
                                .fontWeight(.semibold)
                                .foregroundColor(showBreathView ? .white.opacity(0.6) : .black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background {
                                    if showBreathView {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(Color.white.opacity(0.5))
                                    } else {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(currentType.color)
                                    }
                                }
                                .padding(.horizontal)
                        }
                    )
                }
                .frame(width: size.width, height: size.height, alignment: .bottom)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    private var background: some View {
        GeometryReader { proxy in
            let size = proxy.size
            Image("BG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
                .blur(radius: startAnimation ? 4 : 0, opaque: true)
                .overlay {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                currentType.color.opacity(0.8),
                                .clear,
                                .clear
                            ], startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height)
                            .frame(maxHeight: .infinity, alignment: .top)
                        
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                .clear,
                                .black,
                                .black,
                                .black,
                                .black
                            ], startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height/1.5)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                        
                      
                    }
                }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func breatheView(size: CGSize) -> some View {
        ZStack {
            ForEach(1...8, id: \.self) { index in
                Circle()
                    .fill(currentType.color.opacity(0.5))
                    .frame(width: size.width/2, height: size.width/2)
                    .offset(x: startAnimation ? 0 : 75)
                    .rotationEffect(.init(degrees: Double(index) * 45))
                    .rotationEffect(.init(degrees: startAnimation ? -45 : 0))
            }
        }
        .scaleEffect(startAnimation ? 0.8 : 1)
        .overlay(content: {
            Text("\(count == 0 ? 1 : count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .animation(.easeInOut, value: count)
                .opacity(showBreathView ? 1 : 0)
                .padding()
        })
        .frame(height: size.width)
    }
    
    private func startBreathing() {
        withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.7, blendDuration: 0.7)) {
            showBreathView.toggle()
            
            if showBreathView {
                withAnimation(.easeInOut(duration: 3).delay(0.05)) {
                    startAnimation = true
                }
            } else {
                withAnimation(.easeInOut(duration: 1.5)) {
                    startAnimation = false
                }
            }
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

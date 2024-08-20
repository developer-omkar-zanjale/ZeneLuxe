//
//  LoaderView.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 22/02/24.
//

import SwiftUI

struct LoaderView: View {
    
    @State private var animateLoader = false
    @State private var animateBG = false
    private let colors = [AppColors.topBG, AppColors.midBG, AppColors.bottomBG]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.opacity(0.7)
            
            VStack {
                Circle()
                    .trim(from: animateLoader ? 0  : 1, to: 1)
                    .stroke(lineWidth: 6)
                    .rotationEffect(animateLoader ? .degrees(0) : .degrees(360))
                    .foregroundColor(animateLoader ? colors.randomElement() : .red)
                    .frame(width: screenBounds().width * 0.1, height: screenBounds().width * 0.1)
                    .padding(screenBounds().width * 0.08)
            }
            .background {
                RoundedCorner(radius: screenBounds().width * 0.1, corners: [.topRight, .bottomRight])
                    .foregroundColor(AppColors.primaryTxtColor)
                    
            }
            .padding(.top, screenBounds().height * 0.2)
            .offset(x: animateBG ? 0 : -screenBounds().width * 0.357 )
        }
        .ignoresSafeArea()
        .onAppear {
            asyncQueue {
                withAnimation(.linear.speed(0.2).repeatForever(autoreverses: false)) {
                    animateLoader = true
                }
                
                withAnimation(.linear.speed(0.5)) {
                    animateBG = true
                }
            }
            
           
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}

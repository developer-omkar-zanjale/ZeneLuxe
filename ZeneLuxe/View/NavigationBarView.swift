//
//  NavigationBarView.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 22/02/24.
//

import SwiftUI

struct NavigationBarView: View {
    
    var title: String = ""
    var bgColor: Color = .clear
    var rightIcon: String = ""
    var didTapBack: (()->Void)
    var didTapRightIcon: (()->Void)?
    
    var body: some View {
        ZStack {
            bgColor
            HStack {
                Button {
                    didTapBack()
                } label: {
                    Image(systemName: "chevron.backward.square")
                        .resizable()
                        .frame(width: screenBounds().height * 0.03, height: screenBounds().height * 0.03)
                        .foregroundColor(AppColors.primaryTxtColor)
                }
                .padding(.leading)
                Spacer()
                Text(title)
                    .font(.system(size: screenBounds().height * 0.028, weight: .semibold))
                    .foregroundColor(AppColors.primaryTxtColor)
                Spacer()
                Button {
                    didTapRightIcon?()
                } label: {
                    Image(systemName: rightIcon)
                        .resizable()
                        .frame(width: screenBounds().height * 0.03, height: screenBounds().height * 0.03)
                        .foregroundColor(AppColors.primaryTxtColor)
                }
                .opacity(rightIcon.isEmpty ? 0 : 1)

            }
            .padding(.trailing)
        }
        .frame(height: screenBounds().height * 0.08)
    }
}

struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            NavigationBarView(title: "Title", rightIcon: "xmark.square") {}
        }
        
    }
}

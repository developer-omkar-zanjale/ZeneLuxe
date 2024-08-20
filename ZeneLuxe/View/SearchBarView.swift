//
//  SearchBarView.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 12/02/24.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var input: String
    let placeholder = "Search"
    @State private var isHideSearch = false
    @FocusState private var isfocused: Bool
    
    var body: some View {
        HStack {
            if !isHideSearch {
                Image(systemName: "magnifyingglass.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
            }
            
                
            ZStack(alignment: .leading) {
                TextField("", text: $input)
                    .focused($isfocused)
                    .padding(10)
                    .background(AppColors.topBG)
                Text(placeholder)
                    .padding(.leading, 10)
                    .opacity(input.isEmpty ? 1 : 0)
                    .onTapGesture {
                        isfocused = true
                    }
            }
            .foregroundColor(AppColors.primaryTxtColor)
            .cornerRadius(10)
            .onChange(of: input) { newValue in
                if newValue.isEmpty {
                    withAnimation(.spring().speed(0.8)) {
                        isHideSearch = false
                    }
                } else {
                    if !isHideSearch {
                        withAnimation(.spring().speed(0.8)) {
                            isHideSearch = true
                        }
                    }
                }
            }
        }
        .frame(height: 40)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            SearchBarView(input: .constant(""))
                .padding(.horizontal)
        }
    }
}

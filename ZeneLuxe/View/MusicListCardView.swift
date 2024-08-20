//
//  MusicListCardView.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 12/02/24.
//

import SwiftUI

struct MusicListCardView: View {
    
    @Binding var music: MusicDataModel
    
    @State private var isAnimating: Bool = false
    
    @State private var image: UIImage?
    @State private var isShowBookMarkBtn = false
    @State private var didTapActionBtn = false
    @State private var didTapBookmarkBtn = false
    
    var didTapPlay: (()->Void)
    var didTapBookmark: (()->Void)
    
    var body: some View {
        HStack(spacing: 10) {
            HStack {
                //MARK: Image
                Group {
                    if let img = image {
                        Image(uiImage: img)
                            .resizable()
                            .foregroundColor(.white)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                    }
                }
                .frame(width: screenBounds().width * 0.16, height: screenBounds().width * 0.16)
                .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    Text(music.title)
                    Text(music.artistName)
                        .font(.system(size: screenBounds().width * 0.03, weight: .medium))
                }
                .foregroundColor(AppColors.primaryTxtColor)
                .lineLimit(2)
                .font(.system(size: screenBounds().width * 0.04, weight: .semibold))
                Spacer()
                
                //MARK: Action Button
                
                Image(systemName: getStateIconStr())
                    .resizable()
                    .foregroundColor(music.state == .isPlaying ? .green : .white)
                    .rotationEffect(isAnimating ? .degrees(0) : .degrees(360))
                    .animation(isAnimating ? .linear.speed(0.5).repeatForever(autoreverses: false): .linear, value: isAnimating)
                    .frame(width: screenBounds().width * 0.08, height: screenBounds().width * 0.08)
                    .opacity(didTapActionBtn ? 0 : 1)
                    .animation(Animation.linear(duration: 0.2), value: didTapBookmarkBtn)
                    .onTapGesture {
                        self.didTapActionBtn.toggle()
                        self.setState()
                        didTapPlay()
                        asyncAfter(0.2, completion: {
                            self.didTapActionBtn.toggle()
                        })
                    }
                    .onChange(of: music.state) { newValue in
                        ///Animation on downloading
                        self.isAnimating = (newValue == .isDownloading || newValue == .isDownloadResume)
                    }
            }
            .zIndex(10)
            .padding(16)
            .background(AppColors.topBG)
            .cornerRadius(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColors.primaryTxtColor, lineWidth: 1)
            }
            .onAppear {
                ///Load Image
                ImageLoader.sharedLoader.imageForUrl(music.imageStr) { img, url in
                    self.image = img
                }
            }
            .gesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onEnded({ value in
                        let horizontalAmount = value.translation.width
                        let verticalAmount = value.translation.height
                        
                        if abs(horizontalAmount) > abs(verticalAmount) {
                            withAnimation(Animation.linear.speed(0.8)) {
                                if horizontalAmount < 0 {
                                    self.isShowBookMarkBtn = true
                                } else {
                                    self.isShowBookMarkBtn = false
                                }
                            }
                        }
                    })
            )
            if isShowBookMarkBtn {
                
                Image(systemName: music.isBookmarked ? "bookmark.fill" : "bookmark")
                    .resizable()
                    .frame(width: screenBounds().height * 0.03, height: screenBounds().height * 0.04)
                    .foregroundColor(Color.green)
                    .frame(width: screenBounds().width * 0.07, height: screenBounds().height * 0.07)
                    .tint(AppColors.primaryTxtColor)
                    .padding(16)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.primaryTxtColor, lineWidth: 1)
                    }
                    .background(AppColors.topBG)
                    .opacity(isShowBookMarkBtn ? 1 : 0)
                    .zIndex(8)
                    .cornerRadius(10)
                    .opacity(didTapBookmarkBtn ? 0 : 1)
                    .animation(Animation.linear(duration: 0.2), value: didTapBookmarkBtn)
                    .onTapGesture {
                        self.didTapBookmarkBtn.toggle()
                        music.isBookmarked.toggle()
                        self.didTapBookmark()
                        asyncAfter(0.2, completion: {
                            self.didTapBookmarkBtn.toggle()
                        })
                    }
            }
        }
    }
    ///
    ///Get icon string based on state
    ///
    func getStateIconStr() -> String {
        switch music.state {
        case .ready:
            return "play.circle.fill"
        case .isDownloading:
            return "circle.hexagongrid.circle"
        case .isDownloadPaused:
            return "arrow.down.circle.fill"
        case .isDownloadResume:
            return "circle.hexagongrid.circle"
        case .isPlaying:
            return "stop.circle"
        case .isPaused:
            return "pause.circle"
        }
    }
    ///
    ///Change state based on user tap
    ///
    func setState() {
        switch music.state {
        case .ready:
            music.state = .isDownloading
        case .isDownloading:
            music.state = .isDownloadPaused
        case .isDownloadPaused:
            music.state = .isDownloadResume
        case .isDownloadResume:
            music.state = .isDownloadPaused
        case .isPlaying:
            music.state = .isPaused
        case .isPaused:
            music.state = .isPlaying
        
        }
    }
}

struct MusicListCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            MusicListCardView(music: .constant(MusicDataModel(musicId: 0, imageStr: "https://api.deezer.com/artist/14341199/image", title: "Hancock", artistName: "Dino James", musicPreview: "https://cdns-preview-9.dzcdn.net/stream/c-9471fdb68e2d5a527b8848b1ab87bb08-3.mp3"))) {} didTapBookmark: {}
                .preferredColorScheme(.dark)
                .padding(.horizontal)
        }
    }
}

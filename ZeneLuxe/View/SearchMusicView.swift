//
//  SearchMusicView.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 12/02/24.
//

import SwiftUI

struct SearchMusicView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var musics: FetchedResults<Music>
    
    @ObservedObject private var searchMusicVM = SearchMusicViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [AppColors.topBG, AppColors.midBG, AppColors.bottomBG], startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()
            VStack {
                
                SearchBarView(input: $searchMusicVM.inputTxt)
                    .padding()
                    .onChange(of: searchMusicVM.inputTxt) { newValue in
                        searchMusicVM.localMusicIds = musics.map({Int($0.musicId)})
                        searchMusicVM.didChangeSeacrhInput(searchMusicVM.inputTxt)
                    }
                if searchMusicVM.musicData.count > 0 {
                    List(0..<searchMusicVM.musicData.count, id: \.self) { index in
                        
                        MusicListCardView(music: $searchMusicVM.musicData[index], didTapPlay: {
                            //Play-Pause
                            searchMusicVM.playSong(forIndex: index)
                        }, didTapBookmark: {
                            if searchMusicVM.musicData[index].isBookmarked {
                                self.save(data: searchMusicVM.musicData[index])
                            } else {
                                self.remove(data: searchMusicVM.musicData[index])
                            }
                            
                        })
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                } else {
                    
                    Spacer()
                    
                    NavigationLink(destination: BookmarkView().environment(\.managedObjectContext, viewContext)) {
                        
                        Text("Bookmarks")
                            .padding(16)
                            .foregroundColor(AppColors.primaryTxtColor)
                            .background(AppColors.topBG)
                            .cornerRadius(10)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(AppColors.primaryTxtColor, lineWidth: 1)
                            }
                        
                            .padding(.bottom)
                    }
                    Text(searchMusicVM.inputTxt.isEmpty ? "Search for music" : "No Music found!")
                        .foregroundColor(AppColors.primaryTxtColor)
                        .font(.system(size: screenBounds().width * 0.06))
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
            
        }
        .frame(width: screenBounds().width)
        .navigationBarHidden(true)
        .overlay {
            if searchMusicVM.isShowLoader {
                LoaderView()
            }
        }
    }
    
    func save(data: MusicDataModel) {
        let musicObj = Music(context: viewContext)
        musicObj.musicId = Int64(data.musicId)
        musicObj.artistName = data.artistName
        musicObj.imageStr = data.imageStr
        musicObj.musicPreview = data.musicPreview
        musicObj.title = data.title
        do {
            printLog("Data Saved")
            try viewContext.save()
        } catch {
            printLog("Error Saving bookmark: \(error.localizedDescription)")
        }
    }
    
    func remove(data: MusicDataModel) {
        if let musicObj = self.musics.first(where: {$0.musicId == data.musicId}) {
            do {
                viewContext.delete(musicObj)
                try viewContext.save()
                
                printLog("Data Deleted")
            } catch {
                printLog("Error deleting bookmark: \(error.localizedDescription)")
            }
        }
    }
}

struct SearchMusicView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMusicView()
            .preferredColorScheme(.light)
    }
}

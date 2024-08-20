//
//  BookmarkView.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 20/02/24.
//

import SwiftUI

struct BookmarkView: View {
    
    @FetchRequest(sortDescriptors: []) var musics: FetchedResults<Music>
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject private var bookmarkVM = BookmarkViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [AppColors.topBG, AppColors.midBG, AppColors.bottomBG], startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()
            VStack {
                NavigationBarView(title: "Bookmarks", rightIcon: "xmark.square", didTapBack: {
                    ///Back btn action
                    presentationMode.wrappedValue.dismiss()
                }, didTapRightIcon: {
                    ///Clear all bookmark btn action
                })
                if musics.count > 0 {
                    List(0..<bookmarkVM.musicData.count, id: \.self) { index in
                        
                        MusicListCardView(music: $bookmarkVM.musicData[index], didTapPlay: {
                            //Play-Pause
                            self.bookmarkVM.playSong(forIndex: index)
                        }, didTapBookmark: {
                            self.remove(data: bookmarkVM.musicData[index])
                        })
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                } else {
                    Spacer()
                    Text("No Bookmarks")
                        .foregroundColor(AppColors.primaryTxtColor)
                        .font(.system(size: screenBounds().width * 0.06))
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
        }
        .frame(width: screenBounds().width)
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .onAppear {
            self.refreshData()
        }
    }
    
    func refreshData() {
        self.bookmarkVM.musicData.removeAll()
        for element in musics {
            let obj = MusicDataModel(musicId: Int(element.musicId), imageStr: element.imageStr ?? "-", title: element.title ?? "-", artistName: element.artistName ?? "-", musicPreview: element.musicPreview ?? "-", isBookmarked: true)
            self.bookmarkVM.musicData.append(obj)
        }
        printLog("refreshData")
    }
    
    func remove(data: MusicDataModel) {
        if let musicObj = self.musics.first(where: {$0.musicId == data.musicId}) {
            do {
                viewContext.delete(musicObj)
                try viewContext.save()
                if self.bookmarkVM.musicData.count > 1 {
                    self.bookmarkVM.musicData.removeAll(where: {$0.musicId == data.musicId})
                }
                printLog("Data Deleted")
            } catch {
                printLog("Error deleting bookmark: \(error.localizedDescription)")
            }
        }
    }
}

struct BookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView()
    }
}


struct BookmarkView1: View {
    
    @Binding var d: String
    
    var body: some View {
        ZStack {
            Text(d)
        }
    }
}

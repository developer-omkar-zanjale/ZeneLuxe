//
//  SearchMusicViewModel.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 12/02/24.
//

import Foundation

class SearchMusicViewModel: ObservableObject {
    @Published var musicData: [MusicDataModel] = []
    @Published var isShowAlert: Bool = false
    @Published var inputTxt: String = ""
    @Published var isShowLoader: Bool = false
    @Published var isNavigateToBookmark: Bool = false
    
    var alertMessage: String?
    var localMusicIds: [Int] = []
    
    var musicSearchTimer: Timer?
    
    let service = SearchMusicService()
    let audioService = AudioService()
    
    init() {
//        let obj1 = MusicDataModel(imageStr: "https://api.deezer.com/artist/14341199/image", title: "Dooriyan (feat. Kaprila)", artistName: "Dino James", musicPreview: "https://cdns-preview-9.dzcdn.net/stream/c-9471fdb68e2d5a527b8848b1ab87bb08-3.mp3")
//        musicData.append(obj1)
//        let obj2 = MusicDataModel(imageStr: "https://api.deezer.com/artist/14341199/image", title: "Dooriyan (feat. Kaprila)", artistName: "Dino James", musicPreview: "https://cdns-preview-9.dzcdn.net/stream/c-9471fdb68e2d5a527b8848b1ab87bb08-3.mp3")
//        musicData.append(obj2)
//        let obj3 = MusicDataModel(imageStr: "https://api.deezer.com/artist/14341199/image", title: "Dooriyan (feat. Kaprila)", artistName: "Dino James", musicPreview: "https://cdns-preview-9.dzcdn.net/stream/c-9471fdb68e2d5a527b8848b1ab87bb08-3.mp3")
//        musicData.append(obj3)
//        let obj4 = MusicDataModel(imageStr: "https://api.deezer.com/artist/14341199/image", title: "Dooriyan (feat. Kaprila)", artistName: "Dino James", musicPreview: "https://cdns-preview-9.dzcdn.net/stream/c-9471fdb68e2d5a527b8848b1ab87bb08-3.mp3")
//        musicData.append(obj4)
        audioService.didChangeState = { [weak self] state in
            asyncQueue {
                if let index = self?.audioService.updatingMusicIndex, (self?.musicData.count ?? 0) > index {
                    printLog("State changed: \(state)")
                    self?.musicData[index].state = state
                }
            }
        }
    }
    
    
    func didChangeSeacrhInput(_ str: String) {
        printLog("musicSearchTimer resetting...")
        musicSearchTimer?.invalidate()
        musicSearchTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
            if str.isEmpty {
                self.musicData.removeAll()
            } else {
                self.getSongs(forkey: str)
            }
        })
    }
    
    func resetAllData(skipIndex: Int) {
        for index in 0..<musicData.count {
            if index != skipIndex {
                musicData[index].state = .ready
            }
        }
    }
    
    func getSongs(forkey key: String) {
        printLog("Getting songs: \(key)")
        self.isShowLoader = true
        self.musicData.removeAll()
        service.getSongsBy(key) { data, error in
            if let songs = data {
                self.musicData = songs
            }
            self.updateWithLocalData()
            self.isShowLoader = false
            if let error = error {
                self.alertMessage = error
                self.isShowAlert = true
            }
        }
    }
    
    private func updateWithLocalData() {
        for (index, ele) in self.musicData.enumerated() {
            if let _ = self.localMusicIds.first(where: {$0 == ele.musicId}) {
                printLog("Previosly Bookmarked: \(self.musicData[index].title)")
                self.musicData[index].isBookmarked = true
            }
        }
    }
    
    
    func playSong(forIndex index: Int) {
        printLog("State: \(self.musicData[index].state)")
        self.resetAllData(skipIndex: index)
        audioService.updatingMusicIndex = index
        switch (self.musicData[index].state) {
        case .ready:
            return
        case .isDownloading:
            self.audioService.downloadAndPlay(url: self.musicData[index].musicPreview)
        case .isDownloadPaused:
            self.audioService.downloadService.pauseTask()
        case .isDownloadResume:
            self.audioService.downloadService.resumeTask()
        case .isPlaying:
            self.audioService.resume()
        case .isPaused:
            self.audioService.pause()
        }
        
    }
    
}

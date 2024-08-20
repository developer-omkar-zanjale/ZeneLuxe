//
//  BookmarkViewModel.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 20/02/24.
//

import Foundation
import CoreData


class BookmarkViewModel: ObservableObject {
    
    @Published var musicData: [MusicDataModel] = []
    @Published var isShowAlert: Bool = false
    lazy var alertMessage: String = "Something went wrong!"
    let audioService = AudioService()
    
    init() {
        audioService.didChangeState = { [weak self] state in
            asyncQueue {
                if let index = self?.audioService.updatingMusicIndex, (self?.musicData.count ?? 0) > index {
                    printLog("State changed: \(state)")
                    self?.musicData[index].state = state
                }
            }
        }
    }
    
    func resetAllData(skipIndex: Int) {
        for index in 0..<musicData.count {
            if index != skipIndex {
                musicData[index].state = .ready
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

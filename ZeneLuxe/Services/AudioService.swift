//
//  AudioService.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 13/02/24.
//

import Foundation
import AVFoundation

class AudioService: NSObject {
    //MARK: Properties
    var didShowAlert: ((_ message: String)->Void)?
    var didChangeState: ((TrackState)->Void)?
    let downloadService = DownloadService()
    
    private var player: AVAudioPlayer? = nil
    var updatingMusicIndex: Int?
    
    //MARK: Download Audio
    func downloadAndPlay(url: String) {
        self.stop()
        downloadService.didFinishDownload = { [weak self] location in
            ///Play audio after successful download
            self?.play(location: location)
            self?.didChangeState?(.isPlaying)
        }
        downloadService.startDownload(urlStr: url)
    }
    
    //MARK: Play Audio
    func play(location: URL) {
        if player == nil {
            do {
                printLog("Playing...")
                self.player = try AVAudioPlayer(contentsOf: location)
            } catch {
                print("AudioService Error: \(error.localizedDescription)")
                asyncQueue {
                    self.didShowAlert?(AlertConstant.playerNotFound)
                }
            }
        }
        self.player?.play()
    }
    //MARK: Pause Audio
    func pause() {
        if let player = self.player, player.isPlaying {
            player.pause()
            printLog("Player paused")
        }
    }
    //MARK: Resume Audio
    func resume() {
        if let player = self.player {
            player.play()
            printLog("Player resumed")
        }
    }
    //MARK: Stop Audio
    func stop() {
        if let player = self.player, player.isPlaying {
            player.stop()
            printLog("Player stoped")
        }
        ///Clearing player
        self.player = nil
    }
}

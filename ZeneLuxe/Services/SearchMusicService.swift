//
//  SearchMusicService.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 13/02/24.
//

import Foundation

class SearchMusicService {
    
    let networkManager = NetworkManager()
    
    ///
    ///API Call: Get music by search name
    ///
    func getSongsBy(_ name: String, completion: @escaping (_ data: [MusicDataModel]?, _ error: String?)->Void) {
        let headers = [
            "X-RapidAPI-Key": "599a744a12msh12ecd67b7c4ad46p191e33jsn981adb54aa2f",
            "X-RapidAPI-Host": "deezerdevs-deezer.p.rapidapi.com"
        ]
        let params = ["q": name]
        networkManager.createRequest(method: .GET, path: "search", headers: headers, params: params, body: nil) { data, error in
            asyncQueue {
                if let data = data {
                    let decodedResult = self.decodeMusicData(data)
                    completion(decodedResult.songs, decodedResult.error)
                } else {
                    completion(nil, "No data found!")
                }
            }
        }
    }
    
}

extension SearchMusicService {
    ///
    ///Decode Data to Data model
    ///
    func decodeMusicData(_ data: Data) -> (songs: [MusicDataModel]?, error: String?) {
        do {
            let response = try JSONDecoder().decode(MusicResponseModel.self, from: data)
            
            var songs: [MusicDataModel] = []
            
            for element in response.data ?? [] {
                let songObj = MusicDataModel(musicId: element.id ?? Int.random(in: 0...10000), imageStr: element.artist?.picture ?? "", title: element.title ?? "-", artistName: element.artist?.name ?? "-", musicPreview: element.preview ?? "")
                songs.append(songObj)
            }
            return(songs, nil)
        } catch {
            return (nil, "Unable to decode Data!")
        }
    }
}

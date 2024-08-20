//
//  MusicDataModel.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 12/02/24.
//

import SwiftUI

struct MusicDataModel: Identifiable, Hashable {
    let id = UUID()
    let musicId: Int
    let imageStr: String
    let title: String
    let artistName: String
    let musicPreview: String
    var state: TrackState = .ready
    var isBookmarked: Bool = false
}

//
//  MusicResponseModel.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 12/02/24.
//

import Foundation

struct MusicResponseModel: Decodable {
    let data: [MusicResponse]?
    let total: Int?
    let next: String?
}

// MARK: - MusicResponse
struct MusicResponse: Decodable {
    let id: Int?
    let readable: Bool?
    let title, titleShort, titleVersion: String?
    let link: String?
    let duration, rank: Int?
    let explicitLyrics: Bool?
    let explicitContentLyrics, explicitContentCover: Int?
    let preview: String?
    let md5Image: String?
    let artist: Artist?
    let album: Album?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id, readable, title
        case titleShort = "title_short"
        case titleVersion = "title_version"
        case link, duration, rank
        case explicitLyrics = "explicit_lyrics"
        case explicitContentLyrics = "explicit_content_lyrics"
        case explicitContentCover = "explicit_content_cover"
        case preview
        case md5Image = "md5_image"
        case artist, album, type
    }
}

// MARK: - Album
struct Album: Decodable {
    let id: Int?
    let title: String?
    let cover: String?
    let coverSmall, coverMedium, coverBig, coverXl: String?
    let md5Image: String?
    let tracklist: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id, title, cover
        case coverSmall = "cover_small"
        case coverMedium = "cover_medium"
        case coverBig = "cover_big"
        case coverXl = "cover_xl"
        case md5Image = "md5_image"
        case tracklist, type
    }
}

// MARK: - Artist
struct Artist: Decodable {
    let id: Int?
    let name: String?
    let link, picture: String?
    let pictureSmall, pictureMedium, pictureBig, pictureXl: String?
    let tracklist: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id, name, link, picture
        case pictureSmall = "picture_small"
        case pictureMedium = "picture_medium"
        case pictureBig = "picture_big"
        case pictureXl = "picture_xl"
        case tracklist, type
    }
}

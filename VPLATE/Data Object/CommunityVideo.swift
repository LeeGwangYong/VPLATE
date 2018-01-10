//
//  CommunityVideo.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 10..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation

struct CommunityVideo: Codable {
    let community_id: Int
    let email: String
    let nickname: String
    let profile: String?
    let uploadtime: String
    let content: String
    let uploadvideo: String
    let bookmark: Int
    let hits: Int
}

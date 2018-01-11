//
//  EditorData.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 12..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation

enum EditorType {
    case video, picture, text
}

struct EditorData {
    let sceneNumber: Int
    let clipNumber: Int
    let detail: EditorDetailData
}

struct EditorDetailData {
    let type: EditorType
    let index: [Int]
}

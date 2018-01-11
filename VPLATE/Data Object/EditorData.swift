//
//  EditorData.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 12..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import UIKit

enum EditorType {
    case video, picture, text
}

struct Editors {
    let template_type: String
    let template_length: Int
    let template_thumbnail: String
    let template_hits: Int
    let template_title: String
    let template_id: Int
    let template_hashtag: String
    let template_uploadtime: String
    let template_content: String?
    let editor_Scenes: [EditorData]?
}


struct EditorData {
    let sceneNumber: Int
    let clips: [Any]
    let detail: [EditorDetailData]
}

struct EditorDetailData {
    let type: EditorType
    let indexRatio: [Int : CGFloat?]
}



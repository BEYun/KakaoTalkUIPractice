//
//  DialogList.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/03/29.
//

import Foundation

public struct Dialog: Codable {
    let opponent: User
    var messages: [MessageContent] = []
}

//
//  UserDummyData.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/03/23.
//

import Foundation
import UIKit

// User Dummy Data
var man = User(id: 1, userName: "남자")
var woman = User(id: 2, userName: "여자")
var chatGPT = User(id: 3, userName: "ChatGPT")

// Dialog Dummy Data
var message1 = MessageContent(senderID: man.id, textContent: "안녕하세요. 저는 남자입니다.")
var message2 = MessageContent(senderID: man.id, textContent: "저기요?")

var message3 = MessageContent(senderID: woman.id, textContent: "응 말해.")
var message4 = MessageContent(senderID: woman.id, textContent: "말하하하하ㅏ하라랄라ㅏ라라라라라고고고고ㅗ고고고")

var img = UIImage(named: "1")!.pngData()!
var image1 = MessageContent(senderID: woman.id, imageContent: img)

var kakaoDialogList = Dialog(opponent: woman, messages: [message1, message2, message3, message4, image1])
var chatGPTDialogList = Dialog(opponent: chatGPT, messages: [])






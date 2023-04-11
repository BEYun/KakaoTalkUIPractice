//
//  User.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/03/23.
//

import Foundation
import UIKit

public struct User: Identifiable, Codable {
    public let id: Int
    var userName: String
    var profileImageURL: String = "person.circle"
}

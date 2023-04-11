//
//  KakaoTalkUIPractice + Bundle.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/05.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "ChatGPT", ofType: ".plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_KEY"] as? String else { fatalError("API_KEY가 없습니다.")}
        
        return key
    }
}

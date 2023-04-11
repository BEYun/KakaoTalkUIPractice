//
//  KakaoViewController + TextView.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/04.
//

import UIKit

extension DialogViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        changeTextViewHeight(textView)
        toggleSubmitButton()
    }
}

//
//  ChatGPTEntryView.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/04.
//

import UIKit
import SnapKit
import Then

class ChatGPTEntryView: UIView {
    
    var delegate: PushViewControllerDelegate?
    
    lazy var entryButton = UIButton().then {
        $0.backgroundColor = .systemGreen
        $0.setTitle("ChatGPT 화면", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(entryButtonTapped), for: .touchUpInside)
    }
    
    private func initUI() {
        addSubview(entryButton)
        
        setUpEntryButton()
    }
    
    private func setUpEntryButton() {
        entryButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ChatGPTEntryView Deinit")
    }
    
}

extension ChatGPTEntryView {
    @objc
    private func entryButtonTapped() {
        delegate?.pushVC()
    }
}

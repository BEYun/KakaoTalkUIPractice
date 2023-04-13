//
//  ChatGPTView.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/05.
//

//import UIKit
//import SnapKit
//import Then
//
//protocol ChatGPTViewDelegate: AnyObject {
//    func didTapButton(text: String)
//}
//
//class ChatGPTView: UIView {
//    
//    weak var viewModel: ChatGPTViewModel?
//    weak var delegate: ChatGPTViewDelegate?
//    
//    lazy var inputTextView = UITextView().then {
//        $0.isScrollEnabled = false
//    }
//
//    lazy var callButton = UIButton().then {
//        $0.setTitle("ChatGPT Call!!", for: .normal)
//        $0.setTitleColor(.white, for: .normal)
//        $0.backgroundColor = .black
//        $0.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
//    }
//    
//    init() {
//        super.init(frame: .zero)
//        backgroundColor = .white
//        initUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    deinit {
//        print("ChatGPTView Deinit")
//    }
//}
//
//// MARK: UI Component Layout
//extension ChatGPTView {
//    private func initUI() {
//        // Add Component
//        addSubview(callButton)
//        addSubview(inputTextView)
//
//        // AutoLayout Methods
//        setUpCallButton()
//        setUpInputTextView()
//    }
//    
//    private func setUpCallButton() {
//        callButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().inset(150)
//        }
//    }
//    
//    private func setUpInputTextView() {
//        inputTextView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(100)
//            make.bottom.equalTo(callButton.snp.top).offset(-100)
//        }
//    }
//}
//
//// MARK: Objc Methods
//extension ChatGPTView {
//    @objc
//    private func callButtonTapped() {
//        self.viewModel?.generateResponse(to: "hi", completion: { result, error in
//            guard let result = result else { return }
//            let text = result
//            self.delegate?.didTapButton(text: text)
//        })
//    }
//}

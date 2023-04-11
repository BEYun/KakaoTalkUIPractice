//
//  ChatGPTEntryViewController.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/04.
//

import UIKit

// ChatGPT ID 값
private let OPPONENT_ID = 3

class ChatGPTEntryViewController: UIViewController {

    let chatGPTView = ChatGPTEntryView()
        
    override func loadView() {
        super.loadView()
        self.view = chatGPTView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatGPTView.delegate = self
    }


}

extension ChatGPTEntryViewController: PushViewControllerDelegate {
    func pushVC() {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KakaoViewController")
                as? DialogViewController else { return }
        
        let viewModel = DialogViewModel()
        let dataSourceProvider = DialogDataSourceProvider(dialogViewModel: viewModel, opponentID: OPPONENT_ID)
        
        viewController.dialogViewModel = viewModel
        viewController.dataSourceProvider = dataSourceProvider
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
//    func pushVC() {
//        let apiKey = Bundle.main.apiKey
//        let viewModel = ChatGPTViewModel(apiKey: apiKey)
//        let viewController = ChatGPTViewController(viewModel: viewModel)
//        viewController.hidesBottomBarWhenPushed = true
//
//        self.navigationController?.pushViewController(viewController, animated: true)
//    }
}

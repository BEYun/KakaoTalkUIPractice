//
//  KakaoEntryViewController.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/04.
//

import UIKit

// 상대방 ID
private let OPPONENT_ID = 2

class KakaoEntryViewController: UIViewController {
    let kakaoView = KakaoEntryView()
    
    override func loadView() {
        self.view = kakaoView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kakaoView.delegate = self
    }

}

extension KakaoEntryViewController: PushViewControllerDelegate {
    func pushVC() {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KakaoViewController")
                as? DialogViewController else { return }
        
        let viewModel = DialogViewModel()
        let dataSourceProvider = DialogDataSourceProvider(dialogViewModel: viewModel, opponentID: OPPONENT_ID)
        
        viewController.dialogViewModel = viewModel
        viewController.dataSourceProvider = dataSourceProvider
        print("Push ViewController")
        self.navigationController?.pushViewController(viewController, animated: true)

    }
}

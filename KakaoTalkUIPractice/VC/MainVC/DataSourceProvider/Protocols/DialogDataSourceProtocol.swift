//
//  DialogDataSourceProtocol.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/05.
//

import Foundation
import UIKit

protocol DialogDataSourceProtocol: UITableViewDelegate, UITableViewDataSource {
    var dialogViewModel: DialogViewModel { get }
    
    var dialogCount: Int { get }
    var opponentName: String { get }
}

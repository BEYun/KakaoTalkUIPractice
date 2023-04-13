//
//  DialogDataSourceProvider.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/03/29.
//

import Foundation
import UIKit

class DialogDataSourceProvider: NSObject, DialogDataSourceProtocol {
    let dialogViewModel: DialogViewModel
    
    public var dialogCount: Int {
        return dialogViewModel.getDialogCount()
    }
    public var opponentName: String {
        return dialogViewModel.getOpponentName()
    }
    
    init(dialogViewModel: DialogViewModel, opponentID: Int) {
        self.dialogViewModel = dialogViewModel
        self.dialogViewModel.opponentID = opponentID
        
        self.dialogViewModel.getDialogList()
    }
    
    deinit {
        print("DialogDataSourceProvider Deinit")
    }
    
}

// MARK: UITableView Delegate and DataSource
extension DialogDataSourceProvider: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? DynamicHeightCellProtocol else { return }
        cell.setDynamicHeight()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogViewModel.getDialogCount()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var previousID = 0
        let myDialog = dialogViewModel.dialog.messages
        if indexPath.row > 1 {
            let previousDialog = myDialog[indexPath.row - 1]
            previousID = previousDialog.senderID
        }
        
        let message = myDialog[indexPath.row]
        let date = dialogViewModel.getCurretTime(message.inputDate)
        
        let sender = dialogViewModel.getUser(message.senderID)
        let profileImage = sender.profileImageURL
        
        switch message.senderID {
            
        case dialogViewModel.myID:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyDialogTableViewCell", for: indexPath) as? MyDialogTableViewCell
                else { return MyDialogTableViewCell() }
            cell.configure(message: message, date: date)
            return cell
            
        case dialogViewModel.opponentID where dialogViewModel.opponentID != previousID:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpponentDialogTableViewCell", for: indexPath) as? OpponentDialogTableViewCell
                else { return OpponentDialogTableViewCell() }
            cell.nameLabel.text = sender.userName
            cell.profileImageView.image = UIImage(systemName: profileImage)
            cell.configure(message: message, date: date)
            return cell
            
        case dialogViewModel.opponentID where dialogViewModel.opponentID == previousID:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpponentDialogTableViewCell", for: indexPath) as? OpponentDialogTableViewCell
                else { return OpponentDialogTableViewCell() }
            cell.nameLabel.isHidden = true
            cell.profileImageView.isHidden = true
            cell.configure(message: message, date: date)
            return cell
            
        default:
            return UITableViewCell()
        }
    
    }
}

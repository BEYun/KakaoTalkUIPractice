//
//  DataManager.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/03/29.
//

import Foundation

// ID Default 값
// 사용자와 상대방에 따라 변경되어야 하는 값


protocol UpdateTableViewDelegate: NSObject {
    func updateTableView()
}

class DialogViewModel {
    weak var delegate: UpdateTableViewDelegate?
    
    private let chatGPTnetworkRepository = ChatGPTNetworkRepository(networkService: NetworkService())
    
    let myID: Int = 1
    let chatGPTID = 3
    var opponentID: Int?
    
    private var users: [User] = [man, woman, chatGPT]
    private var dialogList: [Dialog] = []
    
    lazy var opponentDialogIndex = dialogList.firstIndex(where: {$0.opponent.id == opponentID}) ?? 0
    
    let userDefaults = UserDefaults.standard
    
    lazy var dialog = dialogList[opponentDialogIndex] {
        didSet {
            dialogList[opponentDialogIndex] = dialog
        }
    }
    
    // userDefaults set
    func saveDialog(_ dialogList: [Dialog]) {
        var encodedData: [Data] = []
        dialogList.forEach({
            do {
                let data = try JSONEncoder().encode($0)
                encodedData.append(data)
            } catch {
                print(error)
            }
        })
        userDefaults.set(encodedData, forKey: UserDefaultsKey.dialogList.rawValue)
        print("saved!")
    }
    
    // userDefaluts get
    func loadDialog() -> [Dialog] {
        guard let userDefaultData = userDefaults.array(forKey: UserDefaultsKey.dialogList.rawValue) as? [Data] else {
            print("First Loaded!")
            return [kakaoDialogList, chatGPTDialogList]
        }
        var decodedData: [Dialog] = []
        userDefaultData.forEach({
            do {
                let data = try JSONDecoder().decode(Dialog.self, from: $0)
                decodedData.append(data)
            } catch {
                print(error)
            }
        })
        print("loaded!")
        return decodedData
    }
    
    deinit {
        print("DialogViewModel Deinit")
    }

}

// MARK: DialogViewModel Get Methods
extension DialogViewModel {
    func getUser(_ id: Int) -> User {
        guard let user = users.first(where: {$0.id == id}) else { return User(id: 0, userName: "nil") }
        return user
    }
    
    func getOpponentName() -> String {
        guard let opponentID = opponentID else { return ""}
        let opponent = getUser(opponentID)
        return opponent.userName
    }
    
    func getDialogList() {
        dialogList = loadDialog()
    }
    
    func getDialog() -> Dialog {
        return dialog
    }
    
    func getDialogCount() -> Int{
        return dialog.messages.count
    }
    
    func getHourAndMinutes(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

// MARK: DialogViewModel Set Methods
extension DialogViewModel {
    func addTextDialog(_ message: String) {
        var content: MessageContent

        content = MessageContent(senderID: myID, textContent: message)
        dialog.messages.append(content)
        
        if opponentID == chatGPTID {
            chatGPTnetworkRepository.fetchData(query: message, completion: { result in
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            })
        } else {
            saveDialog(dialogList)
        }
    }
    
    func addImageDialog(_ message: Data) {
        let content = MessageContent(senderID: myID, imageContent: message)
        dialog.messages.append(content)
        saveDialog(dialogList)
    }
}

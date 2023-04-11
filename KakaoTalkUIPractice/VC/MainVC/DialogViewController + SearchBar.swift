//
//  KakaoViewController + SearchBar.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/03.
//

import UIKit

extension DialogViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let messages = dialogViewModel?.getDialog().messages else { return }
        var IndexPaths: [IndexPath] = []
        filteredIndexPaths = []
        
        guard let text = searchBar.text else { return }
        
        let filteredArr = messages.enumerated()
            .filter { $0.element.contentType == .text && $0.element.textContent!.contains(text) }
            .map { $0.offset }
        
        if !filteredArr.isEmpty {
            for i in 0..<filteredArr.count {
                let filteredIndex = IndexPath(row: filteredArr[i], section: 0)
                IndexPaths.append(filteredIndex)
            }
            filteredIndexPaths = IndexPaths
            let endIndex = filteredIndexPaths.endIndex - 1
            let endIndexPath = filteredIndexPaths[endIndex]
            
            dialogTableView.scrollToRow(at: endIndexPath, at: .middle, animated: true)
        }
    }
}


//
//  KakaoViewController + PHPicker.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/04/04.
//

import UIKit
import PhotosUI

extension DialogViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
                
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                guard let img = image as? UIImage else { return }
                guard let dialogViewModel = self.dialogViewModel else { return }
                let data = img.compress(to: ImageQuality.normal)
                dialogViewModel.addImageDialog(data)
        
                DispatchQueue.main.async {
                    self.dialogTableView.reloadData()
                    self.scrollToBottomRow()
                }
            }
        }
    }
}

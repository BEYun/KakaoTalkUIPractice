//
//  MyDialogTableViewCell.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/03/28.
//

import UIKit


class MyDialogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: ContentLabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var imageViewConstraint: NSLayoutConstraint? {
            didSet {
                if oldValue != nil {
                    contentImageView.removeConstraint(oldValue!)
                }
                if imageViewConstraint != nil {
                    contentImageView.addConstraint(imageViewConstraint!)
                }
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentLabel?.layer.masksToBounds = true
        contentLabel?.layer.cornerRadius = 15
        contentImageView.layer.masksToBounds = true
        contentImageView.layer.cornerRadius = 15
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 이미 Push Out된 셀 처리하기(불필요한 초기화 방지)
        contentLabel.text = nil
        contentLabel.isHidden = false
        contentImageView.isHidden = true
        self.layoutIfNeeded()
    }
    
    
}

// MARK: Custom Methods
extension MyDialogTableViewCell: DynamicHeightCellProtocol {
    func setDynamicHeight() {
        layoutIfNeeded()
        let newSize = contentLabel.sizeThatFits(CGSize(width: contentLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))
        contentLabel.frame.size = newSize
        layoutIfNeeded()
    }
    
    func setPostedImage(image : UIImage) {
        let aspect = image.size.width / image.size.height
        
        var imgConstraint = NSLayoutConstraint(item: contentImageView!, attribute: .width,
                                                 relatedBy: .equal, toItem: contentImageView,
                                                 attribute: .height, multiplier: aspect, constant: 0.0)
        imgConstraint.priority = UILayoutPriority(999)
        imageViewConstraint = imgConstraint
        contentImageView.image = image
    }

    func configure(message: MessageContent, date: String) {
        let contentType = message.contentType
        switch contentType {
        case .text :
            contentLabel.text = message.textContent
            contentImageView.isHidden = true
        case .image :
            if let data = message.imageContent {
                let img = UIImage(data: data)!
                setPostedImage(image: img)
            }
            contentImageView.isHidden = false
            contentLabel.isHidden = true
        @unknown case _:
            print("ContentType에 추가하기")
        }
        dateLabel.text = date
    }
}

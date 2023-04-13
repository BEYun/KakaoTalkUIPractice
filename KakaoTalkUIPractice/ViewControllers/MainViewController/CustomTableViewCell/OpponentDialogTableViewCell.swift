//
//  OpponentDialogTableViewCell.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/03/28.
//

import UIKit

class OpponentDialogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentLabel: ContentLabel!
    
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
        contentImageView.clipsToBounds = true
        contentImageView.layer.cornerRadius = 15
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.text = nil
        contentLabel.isHidden = false
        profileImageView.isHidden = false
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        nameLabel.isHidden = false
        contentImageView.isHidden = true
        self.layoutIfNeeded()
    }
    

}

// MARK: Custom Methods
extension OpponentDialogTableViewCell: DynamicHeightCellProtocol {
    func setDynamicHeight() {
        layoutIfNeeded()
        let newSize = contentLabel.sizeThatFits( CGSize(width: contentLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))
        contentLabel.frame.size = newSize
        layoutIfNeeded()
    }
    
    func setPostedImage(image : UIImage) {
        let aspect = image.size.width / image.size.height
        guard let contentImageView = contentImageView else { return }
        let imgConstraint = NSLayoutConstraint(item: contentImageView, attribute: .width,
                                                 relatedBy: .equal, toItem: contentImageView,
                                                 attribute: .height, multiplier: aspect, constant: 0.0)
        imgConstraint.priority = UILayoutPriority(999)
        imageViewConstraint = imgConstraint
        self.contentImageView.image = image
    }
    
    func configure(message: MessageContent, date: String) {
        let contentType = message.contentType
        
        switch contentType {
        case .text :
            contentLabel.text = message.textContent
            contentImageView.isHidden = true
            
        case .image :
            if let data = message.imageContent, let img = UIImage(data: data) {
                setPostedImage(image: img)
            }
            contentImageView.isHidden = false
            contentLabel.isHidden = true
        @unknown case _:
            print("ContentType에 추가 할 것 / 예) 동영상 등")
        }
        dateLabel.text = date

    }
}

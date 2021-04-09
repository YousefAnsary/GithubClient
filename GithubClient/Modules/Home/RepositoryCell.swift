//
//  RepositoryCell.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet private weak var avatarImgView: UIImageView!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var ownerLbl: UILabel!
    @IBOutlet private weak var creationDateLbl: UILabel!
    
    override func prepareForReuse() {
        avatarImgView.image = nil
        avatarImgView.cancelImageLoad()
    }
    
    func configureCell(imgURL: String, name: String?, owner: String?, creationDate: String?) {
        avatarImgView.loadImage(fromUrl: URL(string:imgURL))
        nameLbl.text = name
        ownerLbl.text = owner
        creationDateLbl.text = creationDate
    }
    
}

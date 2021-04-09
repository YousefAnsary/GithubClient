//
//  DetailsVC.swift
//  GithubClient
//
//  Created by Yousef on 4/8/21.
//

import UIKit

class RepoDetailsVC: BaseViewController {

    @IBOutlet private weak var issuesCountLbl: UILabel!
    @IBOutlet private weak var starGazersCountLbl: UILabel!
    @IBOutlet private weak var languageLbl: UILabel!
    @IBOutlet private weak var creationDateLbl: UILabel!
    @IBOutlet private weak var descriptionLbl: UILabel!
    @IBOutlet private weak var avatarImgView: UIImageView!
    @IBOutlet private weak var ownerNameLbl: UILabel!
    
    var presenter: RepoDetailsPresenter?
    var coordinator: RepoDetailsCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.getRepoDetails()
    }
    
}

extension RepoDetailsVC: RepoDetailsDelegate {
    
    func setData(_ data: RepoDetailsVM) {
        self.title = data.name
        self.issuesCountLbl.text = String(data.issuesCount ?? 0)
        self.starGazersCountLbl.text = String(data.starGazersCount ?? 0)
        self.languageLbl.text = data.language
        self.creationDateLbl.text = data.creationDate
        self.descriptionLbl.text = data.description
        self.avatarImgView.loadImage(fromUrl: URL(string: data.avatarURL ?? ""))
        self.ownerNameLbl.text = data.ownerName
    }
    
}

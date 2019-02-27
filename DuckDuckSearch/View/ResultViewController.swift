//
//  ResultViewController.swift
//  DuckDuckSearch
//
//  Created by MCS on 2/22/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var textDescription: String = ""
    var textTitle: String = ""
    var imageToLoad: URL?
    
    let vm = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateVC()
    }
    
    func updateVC() {
        descriptionLabel.text = textDescription
        titleLabel.text = textTitle
        
        loadImageToView()
    }
    
    func loadImageToView() {
        if imageToLoad == nil { return }
        activityIndicatorView.startAnimating()
        vm.downloadImageAsset(from: imageToLoad!) { (image) in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.imageView.image = image!
                self.imageView.imageBorderRadius()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
}

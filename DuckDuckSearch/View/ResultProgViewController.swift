//
//  ResultProgViewController.swift
//  DuckDuckSearch
//
//  Created by MCS on 3/3/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class ResultProgViewController: UIViewController {
    
    // MARK: - Properties
    var textDescription: String = ""
    var textTitle: String = ""
    var imageToLoad: URL?
    let vm = SearchViewModel()
    
    // MARK: - Constraints
    var scrollviewConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var viewContainerConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var imageContainerConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var activityIndicatorConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var titleLabelConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var descriptionLabelConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()

    // MARK: - Layouts
    lazy var containerScrollView: UIScrollView = {
       let scrollview = UIScrollView()
        scrollview.backgroundColor = .white
        
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    lazy var viewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.insetsLayoutMarginsFromSafeArea = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizingMask = [.flexibleHeight, .flexibleBottomMargin]

        return view
    }()
    
    lazy var imageViewContainer: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ddg")
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.contentMode = .scaleAspectFit
        imageView.imageBorderRadius()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var progressImageIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .orange
        activityIndicator.hidesWhenStopped = true
       
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textAlignment = .center
        label.font = UIFont(name: "Optima-Bold", size: 35)
       
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.
        
        The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.
        """
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.font = UIFont(name: "Optima-Regular", size: 20)
        label.insetsLayoutMarginsFromSafeArea = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        showViews()
        updateConstraints()
        
        updateVC()
    }

    func showViews() {
        self.view.addSubview(containerScrollView)
        containerScrollView.addSubview(viewContainer)
        viewContainer.addSubview(imageViewContainer)
        viewContainer.addSubview(progressImageIndicator)
        viewContainer.addSubview(titleLabel)
        viewContainer.addSubview(descriptionLabel)
    }
    
    func updateConstraints() {
        // ScrollView Constraints
        scrollviewConstraints = [
            containerScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            containerScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(scrollviewConstraints)
        
        // UIView Container Constraints
        viewContainerConstraints = [
            viewContainer.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            viewContainer.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor),
            viewContainer.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            viewContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ]
        NSLayoutConstraint.activate(viewContainerConstraints)
        
        // UIImageView Container Constraints
        imageContainerConstraints = [
            imageViewContainer.heightAnchor.constraint(equalToConstant: 220),
            imageViewContainer.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 40),
            imageViewContainer.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor)
        ]
        NSLayoutConstraint.activate(imageContainerConstraints)
        
        // UIActivityIndicatorView Constraints
        activityIndicatorConstraints = [
            progressImageIndicator.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
            progressImageIndicator.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor)
        ]
        NSLayoutConstraint.activate(activityIndicatorConstraints)
        
        // titleLabel Constraints
        titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: imageViewContainer.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        // descriptionLabel Constraints
        descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: viewContainer.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(descriptionLabelConstraints)
    }
    
    func loadImageToView() {
        if imageToLoad == nil { return }
        progressImageIndicator.startAnimating()
        vm.downloadImageAsset(from: imageToLoad) { (image) in
            DispatchQueue.main.async {
                self.progressImageIndicator.stopAnimating()
                self.imageViewContainer.image = image!
            }
        }
    }
    
    func updateVC() {
        titleLabel.text = textTitle
        descriptionLabel.text = textDescription
        
        loadImageToView()
    }
    
}

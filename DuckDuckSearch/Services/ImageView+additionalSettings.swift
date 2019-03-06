//
//  ImageView+additionalSettings.swift
//  DuckDuckSearch
//
//  Created by MCS on 2/27/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

extension UIImageView {
    func imageBorderRadius() {
        layer.masksToBounds = true
        layer.borderWidth = 0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = bounds.width/2
        layer.cornerRadius = self.frame.size.height / 2
    }
}

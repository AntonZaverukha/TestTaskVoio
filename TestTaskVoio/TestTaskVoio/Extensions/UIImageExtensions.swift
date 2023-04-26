//
//  UIImageExtensions.swift
//  TestTaskVoio
//
//  Created by Anton on 30.03.2023.
//

import UIKit

extension UIImageView {
    func setImage(from url: URL) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

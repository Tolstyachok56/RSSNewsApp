//
//  UIImageView.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 28.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(from url: URL, withPlaceholder placeholder: UIImage? = nil) {
        self.image = placeholder
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
            }.resume()
    }
}

//
//  TopicViewController.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 02.07.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    //MARK: -
    
    var item: FeedItem?
    
    //MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - View methods
    
    private func setupView() {
        setupImageView()
        setupTitleLabel()
        setupFavoriteButton()
    }
    
    private func setupImageView() {
        self.imageView.image = UIImage(named: "imagePlaceholder")
        if let imageLink = item?.imageLink {
            let imageURL = URL(string: imageLink)
            self.imageView.setImage(from: imageURL!, withPlaceholder: UIImage(named: "imagePlaceholder"))
        }
    }
    
    private func setupTitleLabel() {
        self.titleLabel.text = item?.title
    }
    
    private func setupFavoriteButton() {
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        if let itemIsFavorite = item?.isFavorite, itemIsFavorite == true {
            favoriteButton.setTitle("Remove from favorites", for: .normal)
        } else {
            favoriteButton.setTitle("Add to favorites", for: .normal)
        }
    }
    //MARK: - Actions
    
    @IBAction func favoritePressed(_ sender: UIButton) {
        guard let itemIsFavorite = item?.isFavorite else { return }
        item?.isFavorite = !itemIsFavorite
        updateFavoriteButton()
    }
    
    @IBAction func openInBrowser(_ sender: UIButton) {
        guard let currentItem = item else { return }
        let url = URL(string: currentItem.link!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }

}

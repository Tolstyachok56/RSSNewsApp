//
//  TopicViewController.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 02.07.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import CoreData

class TopicViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var favoriteLabel: UILabel!
    
    //MARK: -
    
    var item: FeedItem?
    
    //MARK: -
    
    var managedObjectContext: NSManagedObjectContext?
    
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
        setupFavoriteLabel()
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
    
    private func setupFavoriteLabel() {
        updateFavoriteLabel()
    }
    
    private func updateView() {
        updateFavoriteButton()
        updateFavoriteLabel()
    }
    
    private func updateFavoriteButton() {
        if let itemIsFavorite = item?.isFavorite, itemIsFavorite == true {
            favoriteButton.setTitle("Remove from favorites", for: .normal)
        } else {
            favoriteButton.setTitle("Add to favorites", for: .normal)
        }
    }
    
    private func updateFavoriteLabel() {
        if let itemIsFavorite = item?.isFavorite {
            favoriteLabel.isHidden = !itemIsFavorite
        }
    }
    
    //MARK: - Actions
    
    @IBAction func favoritePressed(_ sender: UIButton) {
        let itemIsFavorite = (item?.isFavorite)!
        item?.isFavorite = !itemIsFavorite
        
        let favoriteItem = FavoriteItem(context: self.managedObjectContext!)
        managedObjectContext?.performAndWait {
            favoriteItem.title = item?.title
            favoriteItem.url = NSURL(string: (item?.link)!)
            favoriteItem.pubDate = item?.pubDate
            favoriteItem.guid = item?.guid
            if let imageLink = item?.imageLink {
                favoriteItem.imageURL = NSURL(string: imageLink)
            }
        }
        
        updateView()
    }
    
    @IBAction func openInBrowser(_ sender: UIButton) {
        guard let currentItem = item else { return }
        let url = URL(string: currentItem.link!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }

}

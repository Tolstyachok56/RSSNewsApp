//
//  FavoritesTableViewController.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 04.07.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    
    // MARK: - Segue
    
    private enum Segue {
        static let FavoriteItem = "FavoriteItem"
    }
    
    // MARK: - Properties
    
    var parsedData: ParsedData?
    
    // MARK: -
    
    var topicDataSource = FavoriteTopicsDataSource()
    
    // MARK: -
    
    var managedObjectContext: NSManagedObjectContext?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<FavoriteItem> = {
        guard let managedObjectContext = self.managedObjectContext else {
            fatalError("No managed object context found")
        }
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(FavoriteItem.pubDate), ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFavoriteItems()
        updateDataSource()
        tableView.dataSource = topicDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDataSource()
        tableView.reloadData()
    }
    
    // MARK: - Fetching
    
    private func fetchFavoriteItems() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch let fetchError {
            print("Unable to perform fetch")
            print("\(fetchError): \(fetchError.localizedDescription)")
        }
    }
    
    // MARK: - Data source methods
    
    private func updateDataSource() {
        topicDataSource.items = fetchedResultsController.fetchedObjects!
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.FavoriteItem:
            guard let destination = segue.destination as? TopicViewController else { return }
            guard let cell = sender as? TopicTableViewCell else { return }
            destination.item = cell.item
            destination.managedObjectContext = self.managedObjectContext
        default:
            fatalError("Unexpected segue identifier")
        }
    }
    
    //MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

//MARK: - NSFetchedResultsControllerDelegate methods

extension FavoritesTableViewController: NSFetchedResultsControllerDelegate  {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? TopicTableViewCell {
                cell.item = anObject as? FeedItem
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
}

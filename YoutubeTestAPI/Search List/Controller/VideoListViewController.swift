//
//  VideoListViewController.swift
//  YoutubeTestAPI
//
//  Created by Sergio Veliz on 11/7/18.
//  Copyright © 2018 Sergio Veliz. All rights reserved.
//

import UIKit

class VideoListViewController: UITableViewController {
    
    var refreshPage: UIRefreshControl!
    let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    private let timeInterval = 0.4
    
    var searchResponse = SearchResponse()
    
    private let titlePlaceholderSearch = NSLocalizedString("Search video", comment: "Title for placeholder search video")
    private let titleAlert = NSLocalizedString("Sorry", comment: "Title alert")
    private let messageAlert = NSLocalizedString("We can't opened this channel", comment: "Message alert")
    private let actionOk = NSLocalizedString("Ok", comment: "Action ok")
    
    private let reuseIdentifierVideoCell = "VideoTableViewCell"
    private let reuseIdentifierLoadMoreCell = "LoadMoreTableViewCell"
    private let suegueIdentifierShowDetail = "showDetailSegue"
    
    private let imagePlaceholder = UIImage(named: "emptyTumbnail")
    
    var requestSent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = titlePlaceholderSearch
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.delegate = self
        
        // Add Refresh Control to Table View
        if #available(iOS 11.0, *) {
            tableView.refreshControl = refreshPage
        } else {
            tableView.addSubview(refreshPage)
        }
        refreshPage = UIRefreshControl()
        refreshPage.addTarget(self, action: #selector(VideoListViewController.getSearchResult), for: .valueChanged)
        tableView.addSubview(refreshPage)
        
        let loadingCell = UINib(nibName: "LoadMoreTableViewCell", bundle: nil)
        tableView.register(loadingCell, forCellReuseIdentifier: reuseIdentifierLoadMoreCell)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshPage.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let items = searchResponse.items
        if searchResponse.nextPageToken != "" && items.count != 0 {
            return items.count + 1
        }
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if row == searchResponse.items.count {
            return tableView.dequeueReusableCell(withIdentifier: reuseIdentifierLoadMoreCell, for: indexPath) as! LoadMoreTableViewCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierVideoCell, for: indexPath) as! VideoTableViewCell
        let item = searchResponse.items[row]
        
        cell.titleLabel.text = item.snippet.title
        cell.descriptionLabel.text = item.snippet.description
        
        let itemImage = item.snippet.thumbnails.thumbnailsDefault.url.isEmpty
        if !itemImage {
            let imgURL = item.snippet.thumbnails.thumbnailsDefault.url
            cell.coverImage.loadAsyncFrom(url: imgURL, placeholder: imagePlaceholder)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let itemsCount = searchResponse.items.count
        if !requestSent && indexPath.row == itemsCount - 1 {
            getSearchResult()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == suegueIdentifierShowDetail {
            if let indexPath = tableView.indexPathForSelectedRow {
                if searchResponse.items.count != 0 {
                    let row = indexPath.row
                    let videoID = (searchResponse.items[row].id.videoID)
                    if videoID != nil {
                        let controller = segue.destination as! VideoPlayerViewController
                        controller.videoId = videoID!
                    } else {
                        let alertController = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: actionOk, style: .default, handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    // MARK: - Requests
    func createRequestByTimer() {
        guard let text = searchController.searchBar.text else {return}
        if text.count >= 3 {
            searchResponse = SearchResponse()
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(VideoListViewController.getSearchResult), userInfo: nil, repeats: false)
        }
    }
    
    @objc func getSearchResult() {
        requestSent = true
        SearchAPI.getSearchList(searchText: searchController.searchBar.text!, nextPageToken: searchResponse.nextPageToken ) { (searchResponse) in
            if self.searchResponse.items.count == 0 {
                self.searchResponse = searchResponse
                self.tableView.reloadData()
            } else {
                self.searchResponse.items += searchResponse.items
                self.tableView.reloadData()
            }
            self.searchResponse.nextPageToken = searchResponse.nextPageToken
            self.refreshPage.endRefreshing()
            self.requestSent = false
            self.tableView.reloadData()
        }
    }
    
}


extension VideoListViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        createRequestByTimer()
    }
    
}

extension VideoListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        createRequestByTimer()
    }
}

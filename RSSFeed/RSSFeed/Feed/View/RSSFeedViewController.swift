//
//  RSSFeedViewController.swift
//  RSSFeed
//
//  Created by Dominik Kowalski on 18/03/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class RSSFeedViewController: BaseViewController {
    
    var rssFeedView: RSSFeedView { return view as! RSSFeedView }
    
    let viewModel: RSSFeedViewModel
    
    init(viewModel: RSSFeedViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        delegates()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = RSSFeedView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func delegates() {
        super.delegates()
        rssFeedView.tableView.delegate = self
        rssFeedView.tableView.dataSource = self
        
        viewModel.didFinishParsing = { [weak self] in
            self?.rssFeedView.tableView.reloadData()
        }
        
        viewModel.didFailParsing = { [weak self] error in
            let alert = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

extension RSSFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feed?.channels[0].items.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.feed?.channels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? RSSFeedCell {
            cell.configure(withRSSFeedItem: viewModel.feed!.channels[0].items[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
}

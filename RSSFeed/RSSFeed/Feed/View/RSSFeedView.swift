//
//  RSSFeedView.swift
//  RSSFeed
//
//  Created by Dominik Kowalski on 18/03/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class RSSFeedView: BaseView {
    
    let searchBar: SearchView
    let tableView: UITableView
    
    var gestureRecognizer: UITapGestureRecognizer!
    
    let viewModel: RSSFeedViewModel
    
    init(viewModel: RSSFeedViewModel) {
        searchBar = SearchView()
        tableView = UITableView()
        
        self.viewModel = viewModel
        
        super.init()
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func configure() {
        super.configure()
        
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(gestureRecognizer)
        
        customize(self)
        customize(searchBar)
        customize(tableView)
        
        layout(searchBar)
        layout(tableView)
        
        constrain(searchBar)
        constrain(tableView)
    }
    
    override func customize(_ view: UIView) {
        switch view {
        case self:
            backgroundColor = Colors.warmOrange()
        case searchBar:
            searchBar.didTapSearchButton = { [weak self] query in
                self?.viewModel.performSearch(withQuery: query)
            }
        case tableView:
            tableView.allowsSelection = false
            tableView.separatorStyle = .none
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.backgroundView?.backgroundColor = Colors.warmOrange()
            tableView.backgroundColor = Colors.warmOrange()
            tableView.register(RSSFeedCell.self, forCellReuseIdentifier: "itemCell")
        default:
            break
        }
    }
    
    override func layout(_ view: UIView) {
        switch view {
        default:
            addSubview(view)
        }
    }

    override func constrain(_ view: UIView) {
        view.snp.makeConstraints {
            switch view {
            case searchBar:
                $0.top.equalToSuperview().offset(44)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(44)
            case tableView:
                $0.top.equalTo(searchBar.snp.bottom)
                $0.bottom.leading.trailing.equalToSuperview()
            default:
                break
            }
        }
    }
    
    @objc func dismissKeyboard() {
        searchBar.searchTextField.resignFirstResponder()
    }
}

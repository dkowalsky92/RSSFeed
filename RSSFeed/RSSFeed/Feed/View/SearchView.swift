//
//  SearchView.swift
//  RSSFeed
//
//  Created by Dominik Kowalski on 07/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit
import SnapKit

class SearchView: BaseView {

    let searchTextField: UITextField
    let searchButton: UIButton
    
    var didTapSearchButton: ((_ query: String) -> ())?
    
    override init() {
        searchTextField = UITextField(frame: .zero)
        searchButton = UIButton(frame: .zero)
        
        super.init()

        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        customize(self)
        customize(searchTextField)
        customize(searchButton)
        
        layout(searchTextField)
        layout(searchButton)
        
        constrain(searchTextField)
        constrain(searchButton)
    }
    
    override func customize(_ view: UIView) {
        super.customize(view)
        switch view {
        case self:
            backgroundColor = Colors.warmOrange()
        case searchTextField:
            searchTextField.placeholder = "Enter your rss url..."
            searchTextField.font = UIFont.systemFont(ofSize: 14)
            searchTextField.textColor = Colors.grayBlue()
            searchTextField.backgroundColor = Colors.warmOrange()
        case searchButton:
            searchButton.layer.cornerRadius = 4.0
            searchButton.backgroundColor = Colors.paleYellow()
            searchButton.setTitle("Search", for: UIControlState())
            searchButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            searchButton.setTitleColor(Colors.grayBlue(), for: UIControlState())
            searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        default:
            break
        }
    }
    
    override func layout(_ view: UIView) {
        super.layout(view)
        switch view {
        default:
            addSubview(view)
        }
    }
    
    override func constrain(_ view: UIView) {
        super.constrain(view)
        view.snp.makeConstraints {
            switch view {
            case searchTextField:
                $0.top.leading.equalToSuperview().offset(4)
                $0.bottom.equalToSuperview().offset(-4)
            case searchButton:
                $0.leading.equalTo(searchTextField.snp.trailing).offset(16)
                $0.top.equalToSuperview().offset(4)
                $0.trailing.bottom.equalToSuperview().offset(-4)
                $0.width.equalTo(75)
            default:
                break
            }
        }
    }
    
    @objc func searchTapped() {
        didTapSearchButton?(searchTextField.text ?? "")
    }
}

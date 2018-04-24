//
//  RSSFeedCell.swift
//  RSSFeed
//
//  Created by Dominik Kowalski on 19/03/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class RSSFeedCell: UITableViewCell {
    
    let titleLabel: UILabel
    let messageLabel: UILabel
    let dateLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        titleLabel = UILabel()
        messageLabel = UILabel()
        dateLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        customize(contentView)
        customize(titleLabel)
        customize(messageLabel)
        customize(dateLabel)
        
        layout(titleLabel)
        layout(messageLabel)
        layout(dateLabel)
        
        constrain(titleLabel)
        constrain(messageLabel)
        constrain(dateLabel)
    }
    
    func customize(_ view: UIView) {
        switch view {
        case contentView:
            selectionStyle = .none
            contentView.backgroundColor = Colors.grayBlue()
        case titleLabel:
            titleLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
            titleLabel.textColor = Colors.pastelWhite()
            titleLabel.numberOfLines = 0
        case messageLabel:
            messageLabel.font = UIFont.systemFont(ofSize: 12.0)
            messageLabel.textColor = Colors.pastelWhite()
            messageLabel.numberOfLines = 0
        case dateLabel:
            dateLabel.font = UIFont.systemFont(ofSize: 11.0)
            dateLabel.textColor = Colors.pastelWhite()
            dateLabel.numberOfLines = 0
        default:
            break
        }
    }
    
    func layout(_ view: UIView) {
        switch view {
        default:
            contentView.addSubview(view)
        }
    }
    
    func constrain(_ view: UIView) {
        view.snp.makeConstraints {
            switch view {
            case titleLabel:
                $0.top.equalToSuperview().offset(8)
                $0.leading.equalToSuperview().offset(8)
                $0.trailing.equalTo(dateLabel.snp.leading).offset(-8)
                $0.width.greaterThanOrEqualTo(100)
            case messageLabel:
                $0.top.equalTo(titleLabel.snp.bottom).offset(8)
                $0.leading.equalToSuperview().offset(8)
                $0.trailing.equalToSuperview().offset(-8)
                $0.bottom.equalToSuperview().offset(-8)
            case dateLabel:
                $0.top.equalToSuperview().offset(8)
                $0.trailing.equalToSuperview().offset(-8)
                $0.bottom.greaterThanOrEqualTo(messageLabel.snp.top).offset(-8)
                $0.width.greaterThanOrEqualTo(100)
            default:
                break
            }
        }
    }
    
    func configure(withRSSFeedItem item: RSSFeedItem) {
        if let description = item.itemDescription {
            messageLabel.text = description
        }
        
        if let date = item.date {
            dateLabel.text = date.toDisplayString()
        }
        
        if let title = item.title {
            titleLabel.text = title
        }
    }
}

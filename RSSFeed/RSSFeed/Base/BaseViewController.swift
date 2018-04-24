//
//  BaseViewController.swift
//  RSSFeed
//
//  Created by Dominik Kowalski on 18/03/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func navigation() {}
    func delegates() {}
}

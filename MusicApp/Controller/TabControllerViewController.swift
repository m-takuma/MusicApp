//
//  TabControllerViewController.swift
//  MusicApp
//
//  Created by 松尾卓磨 on 2020/10/15.
//  Copyright © 2020 松尾卓磨. All rights reserved.
//

import UIKit

class TabControllerViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

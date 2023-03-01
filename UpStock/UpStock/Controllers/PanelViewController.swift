//
//  PanelViewController.swift
//  UpStock
//
//  Created by Nurali Rakhay on 01.03.2023.
//

import UIKit

class PanelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let grabberView = UIView()
        grabberView.backgroundColor = .label
        grabberView.frame = CGRect(x: 0, y: 0, width: 80, height: 8)
        grabberView.layer.cornerRadius = 5
        grabberView.center = CGPoint(x: view.width / 2, y: 15)
        view.addSubview(grabberView)
        
        view.backgroundColor = .secondarySystemBackground
    }
    



}

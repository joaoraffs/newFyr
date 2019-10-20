//
//  ViewController.swift
//  Fyr
//
//  Created by João Raffs on 19/10/19.
//  Copyright © 2019 Joao Raffs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if Model.instance.phone == "" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "InitialViewStoryboard")
            present(vc!, animated: true)
            self.navigationController?.pushViewController(vc!, animated: true)

        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "MapController")
                       present(vc!, animated: true)
                       self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}


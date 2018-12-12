//
//  ProgressHud.swift
 //  
//
//  Created by Real Estimation on 21.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation
import MBProgressHUD

class ProgressHud: IProgressHud {
    var huds:[String:MBProgressHUD] = [:]
    
    init() {
    }

    func show(id: String) {
        if huds[id] == nil{
            if let view = UIApplication.topViewController()?.view{
                huds[id] = MBProgressHUD.showAdded(to: view, animated: true);
            }
        }
    }
    func dismiss(id: String) {
        if let hud = huds[id]{
            hud.hide(animated: true)
            huds[id] = nil
        }
    }
}

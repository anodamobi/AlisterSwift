//
//  AppDelegate.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 06/12/2018.
//  Copyright (c) 2018 Alexander Kravchenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let carsVC = MainVC()
        let carsNC = UINavigationController(rootViewController: carsVC)
        window?.rootViewController = carsNC
        window?.makeKeyAndVisible()
        
        return true
    }
}

//
//  AppDelegate.swift
//  Holocron
//
//  Created by Alex Agapov on 16/01/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let viewController = SearchViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}


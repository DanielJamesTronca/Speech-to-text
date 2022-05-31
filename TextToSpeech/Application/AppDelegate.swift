//
//  AppDelegate.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 29/05/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let appCoordinator: AppCoordinator = AppCoordinator()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator.rootViewController
        window?.makeKeyAndVisible()
        appCoordinator.start()
        return true
    }
}

//
//  SceneDelegate.swift
//  TestTaskInvolta
//
//  Created by Liza Kostitsina on 9/7/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let networkManager = NetworkManager()
            let presenter = ChatPresenter(networkManager: networkManager)
            let initialVC = ChatViewController(presenter: presenter)
            presenter.view = initialVC
            window.rootViewController = initialVC
            window.backgroundColor = .systemBackground
            self.window = window
            window.makeKeyAndVisible()
        }
    }

}


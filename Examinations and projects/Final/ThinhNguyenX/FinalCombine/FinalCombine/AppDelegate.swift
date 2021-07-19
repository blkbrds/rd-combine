//
//  AppDelegate.swift
//  FinalCombine
//
//  Created by Thinh Nguyen X. [2] VN.Danang on 7/19/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Enums
    enum RootType {
        case signin
        case tutorial
        case home
        case tabbar
    }

    // MARK: - Singleton
    static let shared: AppDelegate = {
        guard let shared = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Cannot cast `UIApplication.shared.delegate` to `AppDelegate`.")
        }
        return shared
    }()

    // MARK: - Properties
    var window: UIWindow?
    let homeVC = HomeVC()
    let signInVC = SignInVC()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configNavi()
        configWindow()
        
        return true
    }

    // MARK: Public Functions
    func setRoot(type: RootType) {
        switch type {
        case .home:
            let navi = UINavigationController(rootViewController: homeVC)
            homeVC.viewModel = HomeViewModel()
            window?.rootViewController = navi
        default:
            let navi = UINavigationController(rootViewController: signInVC)
            window?.rootViewController = navi
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "FinalCombine")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Private function
extension AppDelegate {

    private func configWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        setRoot(type: .signin)
    }

    private func configNavi() {
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.6034153104, green: 0.6034298539, blue: 0.6034219861, alpha: 0.2)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.6034153104, green: 0.6034298539, blue: 0.6034219861, alpha: 0.2)
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.6034153104, green: 0.6034298539, blue: 0.6034219861, alpha: 0.2)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}

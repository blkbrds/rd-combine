//
//  FoodyApp.swift
//  Foody
//
//  Created by An Nguyen T[2] on 2021-08-03.
//  Copyright © 2021 Monstar-Lab All rights reserved.
//

import SwiftUI
import os

@main
struct FoodyApp: App {
    
    @AppStorage("AppState") private var state: AppState = .splash
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var settings = AppSettings()
    @StateObject private var notificationService = UserNotificationsService()
    
    /// Connect to AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @ViewBuilder var rootView: some View {
        state.contentView
    }

    var body: some Scene {
        WindowGroup {
            rootView
                .environmentObject(settings)
                .onAppear(perform: setups)
                .onRotate { orientation in
                    print(orientation.isLandscape)
                }
        }
        .onChange(of: scenePhase) { phase in
            print("App State : ", phase)
        }
    }
}

extension FoodyApp {
    
    private func setups() {
        configNotificationServices()
    }
    
    private func configureState() {
        
    }

    private func configNotificationServices() {
        notificationService.requestAuthorization { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.registerForRemoteNotifications()
                case .failure(let error):
                    Console.log(error.localizedDescription, category: .notification)
                }
            }
        }
    }
    
    private func registerForRemoteNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func unregisterForRemoteNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
}

enum AppState: String {
    case logged, login, splash
    
    var contentView: AnyView {
        switch self {
        case .logged:
            return TabViews().toAnyView
        case .login:
            return NavigationView { LoginView() }.toAnyView
        default:
            return NavigationView { SplashView() }.toAnyView
        }
    }
    
}

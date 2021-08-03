//
//  UserNotificationsService.swift
//  Foody
//
//  Created by An Nguyen T[2] on 2021-08-03.
//  Copyright © 2021 Monstar-Lab All rights reserved.
//

import Foundation
import UserNotifications
import Combine

protocol UserNotificationsServiceable: AnyObject {
    var subscriptions: Set<AnyCancellable> { get set }
    var notificationCenter: UNUserNotificationCenter { get }
    
    var notificationsSettingsPublisher: Publishers.Share<AnyPublisher<UNNotificationSettings, Never>> { get }
    var authorizationStatusPublisher: Publishers.Share<AnyPublisher<UNAuthorizationStatus, Never>> { get }
    
    func getNotificationSettings() -> Future<UNNotificationSettings, Never>
    
    func requestAuthorization(withAbilities authorizationOptions: UNAuthorizationOptions,
                              then completionHandler: ((Result<Bool, Error>) -> Void)?)
    
    func add(_ request: UNNotificationRequest,
             then completionHandler: ((Result<Void, Error>) -> Void)?)
}


extension UserNotificationsServiceable {

    func getNotificationSettings() -> Future<UNNotificationSettings, Never> {
        Future { [weak self] resolve in
            self?.notificationCenter.getNotificationSettings { (settings) in
                resolve(.success(settings))
            }
        }
    }
     

    var notificationsSettingsPublisher: Publishers.Share<AnyPublisher<UNNotificationSettings, Never>> {
        getNotificationSettings()
            .eraseToAnyPublisher()
            .share()
    }
    
    
    var authorizationStatusPublisher: Publishers.Share<AnyPublisher<UNAuthorizationStatus, Never>> {
        notificationsSettingsPublisher
            .map(\.authorizationStatus)
            .eraseToAnyPublisher()
            .share()
    }
  
    
    func requestAuthorization(withAbilities authorizationOptions: UNAuthorizationOptions = [.alert, .badge, .sound],
                              then completionHandler: ((Result<Bool, Error>) -> Void)?) {
        notificationCenter.requestAuthorization(options: authorizationOptions) { (wasGranted, error) in
            if let error = error {
                completionHandler?(.failure(error))
            } else {
                completionHandler?(.success(wasGranted))
            }
        }
    }
    
    
    func add(_ request: UNNotificationRequest, then completionHandler: ((Result<Void, Error>) -> Void)?) {
        notificationCenter.add(request) { (error) in
            if let error = error {
                completionHandler?(.failure(error))
            } else {
                completionHandler?(.success(()))
            }
        }
    }
}


final class UserNotificationsService: NSObject, ObservableObject, UserNotificationsServiceable {
    var notificationCenter: UNUserNotificationCenter
    var authorizationStatus: UNAuthorizationStatus = .notDetermined
    var subscriptions = Set<AnyCancellable>()
    @Published var response: UNNotificationResponse?

    override init() {
        notificationCenter = .current()
        super.init()
        notificationCenter.delegate = self
        authorizationStatusPublisher
            .assign(to: \.authorizationStatus, on: self)
            .store(in: &subscriptions)
    }

    convenience init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.init()
        print("1231232312123")
        self.notificationCenter = notificationCenter
        notificationCenter.delegate = self
    }
}


extension UserNotificationsService {
    static let shared = UserNotificationsService()
}

extension UserNotificationsService: UNUserNotificationCenterDelegate  {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.response = response
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) { }
}

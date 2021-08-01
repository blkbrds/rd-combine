//
//  Scene.swift
//  FinalCombine
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

import UIKit.UIViewController

protocol Scene {
    associatedtype Dependencies
    var viewController: UIViewController { get }
}

//
//  Coordinator.swift
//  Coffee App
//
//  Created by Ameya on 22/11/25.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}

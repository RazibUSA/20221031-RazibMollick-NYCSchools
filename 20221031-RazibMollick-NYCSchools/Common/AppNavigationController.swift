//
//  AppNavigationController.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 10/31/22.
//


import UIKit

class AppNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        
        navigationBar.standardAppearance = standardAppearance
        navigationBar.scrollEdgeAppearance = standardAppearance
        navigationBar.compactAppearance = standardAppearance
    }
}

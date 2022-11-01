//
//  ViewController.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 10/29/22.
//

import UIKit

class HighSchoolListViewController: UIViewController {

    let coordinator: HighSchoolListCoordinator
    
    init(coordinator: HighSchoolListCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "NYC High Schools"
    }

}


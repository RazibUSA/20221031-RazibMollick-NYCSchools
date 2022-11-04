//
//  HighSchoolListCoordinator.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 10/31/22.
//

import Combine
import UIKit

final class HighSchoolListCoordinator: BaseCoordinator<Void> {
    unowned let window: UIWindow
    let productionNetworkDispatcher: SchoolDataFetcher = SchoolDataFetcher(networkDispatcher: NetworkDispatcher())
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> AnyPublisher<Void, Never> {
        let navigationController = AppNavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let viewController = HighSchoolListViewController(coordinator: self,
                                                          dataFatcher: productionNetworkDispatcher)
        navigationController.pushViewController(viewController, animated: true)
        
        return Empty(completeImmediately: false)
            .eraseToAnyPublisher()
    }
}

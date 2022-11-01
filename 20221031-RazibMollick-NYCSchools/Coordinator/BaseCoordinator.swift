//
//  BaseCoordinator.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 10/31/22.
//

import Combine

open class BaseCoordinator<CoordinationResult> {
    
    public var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    @discardableResult
    open func coordinate<T>(to coordinator: BaseCoordinator<T>) -> AnyPublisher<T, Never> {
        
        return coordinator.start()
    }
    
    open func start() -> AnyPublisher<CoordinationResult, Never> {
        fatalError("start() method must be implemented")
    }
}

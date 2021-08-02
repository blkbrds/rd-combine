//
//  UseCaseProvider.swift
//  Domain
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

public protocol UseCaseProvider {
    func makeToDosUseCase() -> ToDosUseCase
    
    func makeToDoDetailUseCase() -> ToDoDetailUseCase
}

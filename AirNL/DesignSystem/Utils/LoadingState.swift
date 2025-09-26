//
//  LoadingState.swift
//  AirNL
//
//  Created by Alejandro on 26/09/25.
//

import Foundation

// MARK: - View State
public enum LoadingState {
    case idle
    case loading
    case loaded
    case failed(Error)
}

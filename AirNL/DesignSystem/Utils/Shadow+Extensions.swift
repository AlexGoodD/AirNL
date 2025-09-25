//
//  Shadow+Extensions.swift
//  AirNL
//
//  Created by Alejandro on 25/09/25.
//

import SwiftUI

enum AppShadowStyle {
    case legacy
    case subtle
    case heavy
}

extension View {
    func appShadow(_ style: AppShadowStyle) -> some View {
        switch style {
        case .legacy:
            return self.shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        case .subtle:
            return self.shadow(color: .black.opacity(0.03), radius: 4, y: 2)
        case .heavy:
            return self.shadow(color: .black.opacity(0.2), radius: 12, y: 6)
        }
    }
    
    func legacyShadow() -> some View {
        self.shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

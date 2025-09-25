//
//  NotificationBanner.swift
//  AirNL
//
//  Created by Alejandro on 25/09/25.
//

import SwiftUI

struct NotificationBanner: View {
    let icon: String
    let title: String?
    let message: String
    var actionTitle: String? = nil
    var onAction: (() -> Void)? = nil
    var onDismiss: (() -> Void)? = nil
    
    @State private var isVisible: Bool = true
    
    var body: some View {
        if isVisible {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding(8)
                
                VStack(alignment: .leading, spacing: 6) {
                    if let title = title {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }

                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let actionTitle = actionTitle {
                        Divider().background(.tertiary)
                        
                        Button(action: {
                            onAction?()
                        }) {
                            Text(actionTitle)
                                .font(.callout)
                                .bold()
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.primary)
                    }
                }
                
                Spacer()
                
                Button(action: dismiss) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(6)
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.background)
                    .legacyShadow()
            )
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.spring(), value: isVisible)
        }
    }
    
    private func dismiss() {
        if let onDismiss = onDismiss {
            onDismiss()
        } else {
            withAnimation {
                isVisible = false
            }
        }
    }
}

#Preview {
    NotificationBanner(
        icon: "exclamationmark.triangle.fill",
        title: nil,
        message: "Weather notifications are turned on for severe weather, rain, and snow near you.",
        actionTitle: "Manage Notifications",
        onAction: {},
        onDismiss: {}
    )
}

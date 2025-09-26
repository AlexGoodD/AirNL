//
//  LoadingState.swift
//  AirNL
//
//  Created by Alejandro on 26/09/25.
//

import SwiftUI

struct LoadingStateView<Content: View>: View {
    let state: LoadingState
    let retry: (() -> Void)?
    let content: () -> Content
    
    var body: some View {
        switch state {
        case .idle, .loading:
            VStack {
                Spacer()
                ProgressView("Loading…")
                    .progressViewStyle(.circular)
                Spacer()
            }
            
        case .failed(let error):
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                Text("Something went wrong")
                    .font(.headline)
                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                if let retry = retry {
                    Button("Retry", action: retry)
                        .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            
        case .loaded:
            content()
        }
    }
}
#Preview {
    LoadingStateView(
        state: .loading,
        retry: nil
    ) {
        Text("Loaded content")
    }
}

//
//  AQICardView.swift
//  AirNL
//
//  Created by Alejandro on 23/09/25.
//

import SwiftUI

struct AQICardView: View {
    var category: String
    var pollutant: String
    var updatedAt: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(category)
                .font(.title.bold())
            Text("Dominant: \(pollutant)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("Updated \(updatedAt.formatted(.dateTime.hour().minute()))")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    AQICardView(category: "Moderate", pollutant: "as", updatedAt: Date())
}

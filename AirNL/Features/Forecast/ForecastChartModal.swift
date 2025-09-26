//
//  ForecastChartModal.swift
//  AirNL
//
//  Created by Alejandro on 26/09/25.
//

import SwiftUI

struct ForecastChartModal: View {
    @StateObject private var vm: ForecastViewModel
    @EnvironmentObject var locationRepo: LocationRepository

    init(repository: any AirRepositoryProtocol) {
        _vm = StateObject(wrappedValue: ForecastViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Picker("Range", selection: $vm.selectedRange) {
                    Text("3 Hours").tag(3)
                    Text("8 Hours").tag(8)
                    Text("12 Hours").tag(12)
                }
                .pickerStyle(.segmented)
                .padding()

                AQISparklineChart(
                    data: vm.sparklineData,
                    chartHeight: 200,
                    showAxis: true
                )
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Forecast")
            #if os(ios)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .task {
                await vm.refreshFromLocation(locationRepo.userLocation)
            }
        }
    }
}

#Preview {
    ForecastChartModal(repository: MockAirRepository())
}

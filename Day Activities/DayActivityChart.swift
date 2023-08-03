//
//  DayActivityChart.swift
//  Day Activities
//
//  Created by Nikolay Kavretsky on 31.07.2023.
//

import SwiftUI
import Charts

struct DayActivityChart: View {
    @EnvironmentObject var typeStore: TypeStore
    private var chartVM: ChartViewModel
    
    init(data: [Activity]) {
        self.chartVM = ChartViewModel(data: data)
    }
    
    private func typeToColor(typeID: String) -> Color {
        Color(rgbaColor: typeStore.type(withID: typeID).backgroundRGBA)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Chart(chartVM.chartData) { chartData in
                BarMark(
                    x: .value("Hour", chartData.startTime, unit: .hour),
                    y: .value("Duration", chartData.duration)
                )
                .foregroundStyle(by: .value("Duration", chartData.type))
                .cornerRadius(3)
            }
            .chartYScale(domain: [0, 60])
            .chartXScale(domain: [Date.startOfDay(), Date.endOfDay()])
            .chartForegroundStyleScale { typeID in
                typeToColor(typeID: typeID)
            }
        }
    }
}

struct DayActivityChart_Previews: PreviewProvider {
    static var previews: some View {
        
        DayActivityChart(data: [
                        Activity(name: "Test", typeID: .init(), startDateTime: .now, finishDateTime: .now.addingTimeInterval(TimeInterval(300))),
                        Activity(name: "Test2", typeID: .init(), startDateTime: .now.addingTimeInterval(3600), finishDateTime: .now.addingTimeInterval(8650)),
                        Activity(name: "Test3", typeID: .init(), startDateTime: .now.addingTimeInterval(8650), finishDateTime: .now.addingTimeInterval(15650))
        ])
        .scaledToFit()
        .environmentObject(TypeStore())
    }
}

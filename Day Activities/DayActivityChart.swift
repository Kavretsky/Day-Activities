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
    
    private func colorForTypeID(_ typeID: String) -> Color {
        Color(rgbaColor: typeStore.type(withID: typeID).backgroundRGBA)
    }
    
    var body: some View {
        barChart
    }
    
    private var barChart: some View {
        Chart(chartVM.chartData) { chartData in
            BarMark(
                x: .value("Hour", chartData.startTime, unit: .hour),
                y: .value("Duration", chartData.duration)
            )
            .foregroundStyle(by: .value("Duration", chartData.typeID))
            .cornerRadius(3)
        }
        .chartYScale(domain: [0, 60])
        .chartXScale(domain: [Date.startOfDay(), Date.endOfDay()])
        .chartForegroundStyleScale { typeID in
            colorForTypeID(typeID)
        }
//        .chartYAxis {
//            AxisMarks(format: .timeDuration, values: <#T##AxisMarkValues#>)
//        }
        .chartLegend(position: .bottom, alignment: .leading) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(chartVM.usedTypes, id: \.self) { typeID in
                        HStack {
                            BasicChartSymbolShape.circle
                                .foregroundColor(colorForTypeID(typeID))
                                .frame(width: 8, height: 8)
                            Text(typeStore.type(withID: typeID).description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
        }
    }
    

}

struct DayActivityChart_Previews: PreviewProvider {
    static var previews: some View {
        let sample = [
            Activity(name: "Test", typeID: "C286CACB-51A6-4FD8-87E1-6900C8ECC1A9", startDateTime: .now, finishDateTime: .now.addingTimeInterval(TimeInterval(300))),
            Activity(name: "Test2", typeID: "C286CACB-51A6-4FD8-87E1-6900C8ECC1A9", startDateTime: .now.addingTimeInterval(3600), finishDateTime: .now.addingTimeInterval(8650)),
            Activity(name: "Test3", typeID: "4300197B-201F-42CC-AB52-67186E41F668", startDateTime: .now.addingTimeInterval(8650), finishDateTime: .now.addingTimeInterval(15650))
        ]
        DayActivityChart(data: sample)
            .environmentObject(TypeStore())
            .scaledToFit()
    }
}

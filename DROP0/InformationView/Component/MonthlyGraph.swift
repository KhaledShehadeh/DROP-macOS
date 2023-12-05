//
//  MonthlyGraph.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 28/11/2023.
//

import SwiftUI
import Charts

struct WaterGraph: View
{
	let data: [Double?]
	let yearly: Bool
	
	func color(number: Double) -> Color
	{
		if number < 0
		{
			return Color.init(hue: 1, saturation: abs(number) / 5, brightness: 1)
		}
		else
		{
			return Color.init(hue: 0.6, saturation: number / 5, brightness: 1)
		}
	}
	
	func createDate(index: Int) -> Date
	{
		var components = DateComponents()
		components.year = 2002
		components.month = 6
		let startingDate = Calendar.current.date(from: components)!
		
		return Calendar.current.date(byAdding: .month, value: index, to: startingDate)!
	}
	
	var body: some View
	{
		Chart
		{
			ForEach(Array(data.enumerated()), id: \.element)
			{
				index, number in
				
				BarMark(x:.value("Time", createDate(index: index), unit: yearly ? .year : .month), y: .value("Water Level", number ?? 0)).foregroundStyle(color(number: number ?? 0))
				
			}
		}
		.chartXAxis(.visible)
		
		
	}
}

#Preview 
{
	WaterGraph(data: VMMap().allCountries[0].properties.monthlyAverage ?? [], yearly: true)
		.frame(width: 1000)
}

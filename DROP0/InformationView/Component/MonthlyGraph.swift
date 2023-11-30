//
//  MonthlyGraph.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 28/11/2023.
//

import SwiftUI
import Charts

struct MonthlyGraph: View 
{
	let data: [Double?]
	
	func color(number: Double) -> Color
	{
		if number < 0
		{
			return Color.init(hue: 1, saturation: abs(number) / 2, brightness: 1)
		}
		else
		{
			return Color.init(hue: 0.6, saturation: number / 2, brightness: 1)
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
				
				BarMark(x:.value("Date", createDate(index: index), unit: .month), y: .value("Water Level", number ?? 0)).foregroundStyle(color(number: number ?? 0))
				
			}
		}
		
		
	}
}

#Preview 
{
	MonthlyGraph(data: VMMap().allCountries[0].properties.monthlyAverage ?? [])
		.frame(width: 1000)
}

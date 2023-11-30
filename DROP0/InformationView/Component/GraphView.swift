//
//  GraphView.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 23/11/2023.
//

import SwiftUI
import Charts

struct GraphView: View 
{
	let data: [Double]
	
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
		let startingDate = Calendar.current.date(from: components)!
		
		return Calendar.current.date(byAdding: .year, value: index, to: startingDate)!
	}
	
    var body: some View
	{
		Chart
		{
			ForEach(Array(data.enumerated()), id: \.element)
			{
				index, number in
				
				BarMark(x: .value("Month", createDate(index: index)), y: .value("Water Level", number)).foregroundStyle(color(number: number))
				
			}
		}
    }
}

#Preview 
{
	GraphView(data: [2, 1, -3, 1, -2])
		.padding()
}

//
//  QuickInfoView.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 23/11/2023.
//

import SwiftUI

struct QuickInfoView: View
{
	let country: ModelCountry.Properties
	@Binding var selectedCountry: ModelCountry.Properties?
	
	private func color() -> Color
	{
		let opacity = 0.6
		if country.region == .Northern
		{
			return Color.purple.opacity(opacity)
		}
		else if country.region == .Southern
		{
			return Color.red.opacity(opacity)
		}
		else if country.region == .Eastern
		{
			return Color.gray.opacity(opacity)
		}
		else if country.region == .Western
		{
			return Color.yellow.opacity(opacity)
		}
		else
		{
			return Color.orange.opacity(opacity)
		}
	}
	
	private func deviation() -> Double?
	{
		func calculateMean(numbers: [Double]) -> Double
		{
			let sum = numbers.reduce(0, +)
			let mean = sum / Double(numbers.count)
			return mean
		}
		
		guard let numbers = country.yearlyAverage else {return nil}
		
		let deviation = calculateMean(numbers: Array(numbers[15...20])) - calculateMean(numbers: Array(numbers.prefix(15)))
		
		return round(deviation * 100) / 100
	}
	
	var body: some View
	{
		VStack
		{
			HStack
			{
				Spacer()
				
				Button
				{
					selectedCountry = nil
				} label: {
					Image(systemName: "x.circle")
						.padding(7)
				}
			}
			
			Image(country.name)
				.resizable()
				.scaledToFit()
				.frame(height: 100)
			
			HStack(alignment: .top)
			{
				VStack(alignment: .leading)
				{
					Text(country.name)
						.font(.title)
						.bold()
					
					Text(country.region.rawValue + " Africa")
						.foregroundStyle(color())
						.font(.callout)
						.fontWeight(.bold)
				}
				
				Spacer()
				
				NavigationLink
				{
					InformationView(country: country)
				} label: {
					Label("Explore", systemImage: "chevron.right")
						.lineLimit(1)
						.padding()
				}
				.buttonStyle(.borderedProminent)
			}
			.padding(.horizontal, 3)
			.padding(.bottom)
			
			if let averages = country.monthlyAverage
			{
//				GraphView(data: averages)
//					.frame(height: 500)
				
				WaterGraph(data: averages, yearly: true)
					.frame(height: 500)
			}
			
			
			
			
		}
	}
}

#Preview(traits: .sizeThatFitsLayout)
{
	QuickInfoView(country: VMMap().allCountries[0].properties, selectedCountry: .constant(ModelCountry.Properties(name: "", symbol: "", region: .Central)))
		.padding(.horizontal, 10)
		.padding(.vertical, 20)
}

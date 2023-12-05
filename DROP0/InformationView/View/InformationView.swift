//
//  InformationView.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 23/11/2023.
//

import SwiftUI

struct InformationView: View 
{
	@StateObject private var vmInfo: VMInformation
	
	@Environment(\.dismiss) private var dismiss
	
	init(country: ModelCountry.Properties)
	{
		_vmInfo = StateObject(wrappedValue: VMInformation(country: country))
	}
	
	var body: some View
	{
		VStack
		{
			HStack(spacing: 30)
			{
				Button
				{
					dismiss()
				} label:
				{
					Label("Back", systemImage: "chevron.left")
						.padding()
				}
				.padding()
				
				Spacer()
				
				Text(vmInfo.country.name + " Underground Water Levels")
					.font(.title)
					.bold()
				
				Spacer()
				
				Spacer()
					.frame(width: 100)
				
			}
			
			if let monthlyData = vmInfo.monthlyData
			{
				WaterGraph(data: monthlyData, yearly: false)
					.frame(height: 600)
					.padding(.horizontal)
			}
			
			Text("Monthly")
				.font(.title)
				.bold()
			
			Spacer()
		}
		.preferredColorScheme(.dark)
	}
}

#Preview 
{
	NavigationStack
	{
		InformationView(country: VMMap().allCountries[0].properties)
			.frame(width: 900, height: 500)
			.preferredColorScheme(.dark)
	}
}

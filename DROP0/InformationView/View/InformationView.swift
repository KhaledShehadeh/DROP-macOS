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
	
	@State private var graphSelection: Graph = .Year
	
	@Environment(\.dismiss) private var dismiss
	
	init(country: ModelCountry.Properties)
	{
		_vmInfo = StateObject(wrappedValue: VMInformation(country: country))
	}
	
	enum Graph: String, CaseIterable
	{
		case Year
		case Month
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
			
			TabView(selection: $graphSelection)
			{
			
				if let yearlyData = vmInfo.yearlyData
				{
					GraphView(data: yearlyData)
						.frame(height: 600)
						.padding(.horizontal)
						.tag(Graph.Year)
				}
				
				if let monthlyData = vmInfo.monthlyData
				{
					MonthlyGraph(data: monthlyData)
						.frame(height: 600)
						.padding(.horizontal)
						.tag(Graph.Month)
				}
			}
			.tableStyle(.bordered)
			
			Text(graphSelection.rawValue)
				.font(.title)
				.bold()
			
			Spacer()
			/*
			VStack(spacing: 50)
			{
				Text("Yearly Water Levels")
					.font(.title)
					.fontWeight(.bold)
					.foregroundStyle(.blue)
				
				GraphView(data: vmInfo.yearlyData)
					.frame(height: 600)
					.padding(.horizontal)
				
				HStack
				{
					
					Image("graph1")
						.resizable()
						.scaledToFit()
						.frame(width: 400, height: 400)
						.padding(.top)
					
				
					Spacer()
				}
				
			}
			 */
		}
	}
}

#Preview 
{
	InformationView(country: VMMap().allCountries[0].properties)
		.frame(width: 1500, height: 1000)
}

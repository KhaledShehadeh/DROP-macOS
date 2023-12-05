//
//  MexicoStateGraph.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 05/12/2023.
//

import SwiftUI

struct MexicoStateGraph: View 
{
	@Environment(\.dismiss) private var dismiss
	
	let state: ModelMexicoState.Properties
	
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
				
				Text(state.name + " Underground Water Levels")
					.font(.title)
					.bold()
				
				Spacer()
				
				Image(.mexicoFlagMap)
					.resizable()
					.scaledToFit()
					.frame(width: 100)
					.padding(.trailing)
				
			}
			
			if let monthlyData = state.monthlyAverage
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
    }
}

#Preview 
{
	MexicoStateGraph(state: VMMexicoMap().states[0].properties)
}

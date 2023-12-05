//
//  MexicoStateInfo.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 05/12/2023.
//

import SwiftUI

struct MexicoStateInfo: View 
{
	let state: ModelMexicoState.Properties
	@Binding var selectedState: ModelMexicoState.Properties?
	
	var body: some View
	{
		VStack
		{
			HStack
			{
				Spacer()
				
				Button
				{
					selectedState = nil
				} label: {
					Image(systemName: "x.circle")
						.padding(7)
				}
			}
			
			Image(.mexicoFlag)
				.resizable()
				.scaledToFit()
				.frame(height: 100)
			
			HStack(alignment: .top)
			{
				Text(state.name)
					.font(.title)
					.bold()
				
				Spacer()
				
				NavigationLink
				{
					MexicoStateGraph(state: state)
				} label: {
					Label("More", systemImage: "chevron.right")
						.lineLimit(1)
						.padding()
				}
				.buttonStyle(.borderedProminent)
			}
			.padding(.horizontal, 3)
			.padding(.bottom)
			
			if let averages = state.monthlyAverage
			{
				WaterGraph(data: averages, yearly: true)
					.frame(height: 500)
			}
			
		}
	}
}

#Preview {
	MexicoStateInfo(state: VMMexicoMap().states[0].properties, selectedState: .constant(nil))
}

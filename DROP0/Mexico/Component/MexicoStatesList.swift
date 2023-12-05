//
//  MexicoStatesList.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 05/12/2023.
//

import SwiftUI

struct MexicoStatesList: View 
{
	@Binding var selected: ModelMexicoState.Properties?
	@Binding var showStateList: Bool
	
	let states: [ModelMexicoState.Properties]
	
	init(selected: Binding<ModelMexicoState.Properties?>, states: [ModelMexicoState], showStateList: Binding<Bool>)
	{
		self._selected = selected
		self._showStateList = showStateList
		var allStates: [ModelMexicoState.Properties] = []
		for state in states
		{
			allStates.append(state.properties)
		}
		self.states = allStates.sorted(by: { $0.name < $1.name })
	}
	
	private func colorText(state: ModelMexicoState.Properties) -> Color
	{
		if selected == state
		{
			Color.init(nsColor: .blue)
		}
		else
		{
			Color.init(nsColor: .alternateSelectedControlTextColor)
		}
	}
	
	var body: some View
	{
		ScrollView
		{
			LazyVStack(spacing: 25)
			{
				ForEach(states, id: \.self)
				{
					state in
					
					list(state: state)
						.onTapGesture(count: 1, perform:
										{
							withAnimation
							{
								self.selected = state
							}
						})
					
				}
			}
			.padding(.vertical)
			.padding(.horizontal, 7)
			
		}
		.scrollIndicators(.visible)
		.background(.thinMaterial.opacity(0.9))
		
	}
	
	private func list(state: ModelMexicoState.Properties) -> some View
	{
		HStack(spacing: 15)
		{
			Image(.mexicoFlag)
				.resizable()
				.scaledToFit()
				.frame(width: 50)
				.foregroundStyle(.black)
			
			if selected == state
			{
				Image(systemName: "chevron.right")
			}
			Text(state.name)
				.foregroundStyle(colorText(state: state))
				.font(.headline)
				.bold()
				.lineLimit(1)
			
			Spacer()
		}
	}
}

#Preview 
{
	MexicoStatesList(selected: .constant(nil), states: VMMexicoMap().states, showStateList: .constant(false))
}

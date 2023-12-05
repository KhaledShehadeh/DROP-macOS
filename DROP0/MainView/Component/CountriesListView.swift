//
//  CountriesListView.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 23/11/2023.
//

import SwiftUI

struct CountriesListView: View 
{
	@Binding var selected: ModelCountry.Properties?
	@Binding var showCountryList: Bool
	
	let countries: [ModelCountry.Properties]
	
	init(selected: Binding<ModelCountry.Properties?>, countries: [ModelCountry], showCountryList: Binding<Bool>)
	{
		self._selected = selected
		self._showCountryList = showCountryList
		var allCountries: [ModelCountry.Properties] = []
		for country in countries
		{
			allCountries.append(country.properties)
		}
		self.countries = allCountries.sorted(by: { $0.name < $1.name })
	}
	
	#if os(iOS)
	private func colorText(country: ModelCountry.Properties) -> Color
	{
		if selected == country
		{
			Color.init(uiColor: .link)
		}
		else
		{
			Color.init(uiColor: .secondaryLabel)
		}
	}
	#else
	private func colorText(country: ModelCountry.Properties) -> Color
	{
		if selected == country
		{
			Color.init(nsColor: .blue)
		}
		else
		{
			Color.init(nsColor: .alternateSelectedControlTextColor)
		}
	}
	#endif
	
	var body: some View
	{
		ScrollView
		{
			LazyVStack(spacing: 25)
			{
				ForEach(countries, id: \.self)
				{
					country in
					
					list(country: country)
						.onTapGesture(count: 1, perform: 
										{
							withAnimation
							{
								self.selected = country
							}
						})
						.gesture(DragGesture(minimumDistance: 40, coordinateSpace: .local)
							.onEnded({ value in
								if value.translation.width > 0
								{
									withAnimation(.snappy)
									{
										showCountryList = false
									}
								}
							}))
					
				}
			}
			.padding(.vertical)
			.padding(.horizontal, 7)
			
			
		}
		.scrollIndicators(.visible)
		.background(.thinMaterial.opacity(0.9))
		
	}
	
	private func list(country: ModelCountry.Properties) -> some View
	{
		HStack(spacing: 15)
		{
			Image(country.name)
				.resizable()
				.scaledToFit()
				.frame(width: 50)
				.foregroundStyle(.black)
			
			if selected == country
			{
				Image(systemName: "chevron.right")
			}
			Text(country.name)
				.foregroundStyle(colorText(country: country))
				.font(.headline)
				.bold()
				.lineLimit(1)
			
			Spacer()
		}
	}
}

#Preview 
{
	CountriesListView(selected: .constant(.init(name: "Morocco", symbol: "MC", region: .Northern)), countries: VMMap().allCountries, showCountryList: .constant(false))
		.preferredColorScheme(.dark)
}

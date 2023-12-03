//
//  MainMapView.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 23/11/2023.
//

import SwiftUI
import MapKit



struct MainMapView: View
{
	@StateObject private var vm = VMMap()
	
//	@State private var position: MapCameraPosition = .automatic
	
	@State private var showingQRCode = false
	
	@State private var selected: ModelCountry.Properties?
	
	@State private var showCountryList = false
	@State private var sattelite = false
	@State private var waterMap = false
	
	@State private var slider: Double = 0
	
	private func color(country: ModelCountry.Properties) -> Color
	{
		let opacity = 0.7
		if waterMap
		{
			if let waterLevel = country.yearlyAverage?[Int(slider)]
			{
				if waterLevel < 0
				{
					let maxValue = 20.0
					let percent = abs(waterLevel) / maxValue
					return Color.init(hue: 1, saturation: percent, brightness: 1).opacity(opacity)
				}
				else
				{
					let maxValue = 20.0
					let percent = abs(waterLevel) / maxValue
					return Color.init(hue: 0.6, saturation: percent, brightness: 1).opacity(opacity)
				}
				
			}
			else
			{
				return .gray
			}
		}
		else
		{
			if selected == country
			{
				return Color.black.opacity(opacity)
			}
			return country.region.color.opacity(opacity)
		}
	}
	
	var body: some View
	{
		Map(selection: $selected)
		{
			ForEach(vm.allCountries)
			{
				country in
				
				if let coordinates = country.geometry.coordinates
				{
					
					ForEach(coordinates, id: \.first?.latitude)
					{
						coordinate in
						
						MapPolygon(coordinates: coordinate)
							.foregroundStyle(color(country: country.properties))
					}
					
					if !waterMap
					{
						Marker(country.properties.name, systemImage: "drop.fill", coordinate: coordinates[0][0])
							.tint(selected == country.properties ?
								  Color.white :
									Color.init(hue: 0.6, saturation: 1, brightness: 1))
							.tag(country.properties)
					}
					else if sattelite
					{
						Annotation(country.properties.name, coordinate: coordinates[0][0])
						{
							VStack
							{
								
							}
						}
					}
					
				}
				
				
			}
			
		}
		.mapStyle(sattelite ? .imagery(elevation: .realistic) : .standard)
		#if os(macOS)
		.mapControls {
			MapCompass()
			MapScaleView()
			MapZoomStepper()
				.controlSize(.extraLarge)
		}
		.mapControlVisibility(.visible)
		.safeAreaInset(edge: .top, alignment: .leading) {
			
			HStack
			{
				Image("Droplogo2")
					.resizable()
					.scaledToFit()
					.frame(height: 100)
				
				Rectangle()
					.frame(width: 2)
					.padding(.vertical)
					
				Image("NSSTClogo")
					.resizable()
					.scaledToFit()
					.frame(height: 50)
			}
			.frame(height: 100)
			.padding(.top)
			.padding(.leading)
			.onTapGesture {
				showingQRCode.toggle()
			}
		}
		#else
		.safeAreaInset(edge: .bottom) {
			VStack(spacing: 20)
			{
				if let selected = self.selected
				{
					QuickInfoView(country: selected)
				}
				TabBar(showCountriesList: $showCountryList, sattelite: $sattelite, waterMap: $waterMap, slider: $slider)
			}
			.padding(.top)
			.padding(.horizontal)
			.background(.thinMaterial)
		}
		#endif
		.overlay {
			overlay
		}
//		.onChange(of: waterMap) { _, _ in
//			selected = nil
//		}
		
	}
}

extension MainMapView
{
	#if os(macOS)
	
	var overlay: some View
	{
		ZStack
		{
			
			VStack
			{
				Spacer()
				HStack
				{
					if let selected = self.selected
					{
						QuickInfoView(country: selected, selectedCountry: $selected)
							.frame(width: 500)
							.padding()
							.background(.thinMaterial)
							.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
					}
					
					Spacer()
				}
			}
			.padding()
			.padding(.top)
			
			VStack
			{
				HStack
				{
					Spacer()
					
					if showCountryList
					{
						CountriesListView(selected: $selected, countries: vm.allCountries, showCountryList: $showCountryList)
							.frame(width: 300)
							.clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 0, topTrailingRadius: 0, style: .continuous))
							.transition(.move(edge: .trailing))
					}
					
					if waterMap
					{
						WaterLevelLegend()
							.padding(.trailing)
							.frame(height: 500)
					}
					
				}
				
				Spacer()
				
				HStack(alignment: .bottom)
				{
					if waterMap
					{
						Spacer()
							.frame(width: 300)
						
						Spacer()
						
						VStack(alignment: .leading, spacing: 20)
						{
							HStack
							{
								Text("Year \(String(Int(slider + 2002)))")
									.font(.title2)
									.bold()
								
								Spacer()
								
								Button
								{
									if slider > 0
									{
										slider -= 1
									}
								} label: {
									Image(systemName: "chevron.left")
										.font(.title)
										.padding(10)
								}
								.disabled(slider <= 0)
								
								
								Button
								{
									if slider < 20
									{
										slider += 1
									}
								} label: {
									Image(systemName: "chevron.right")
										.font(.title)
										.padding(10)
								}
								.disabled(slider >= 20)
								
							}
							Slider(value: $slider, in: 0...20, step: 1)
						}
						.frame(width: 600)
						.padding(.horizontal, 20)
						.padding(.vertical, 10)
						.background(.ultraThinMaterial)
						.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
					}
					
					Spacer()
					
					TabBar(showCountriesList: $showCountryList, sattelite: $sattelite, waterMap: $waterMap, slider: $slider)
						.frame(width: 230)
						.padding(.vertical)
						.background(.thinMaterial)
						.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
				}
			}
			.padding()
			
			if showingQRCode
			{
				VStack(spacing: 0)
				{
					HStack
					{
						Text("Share your Contact info.")
						
						
						
						Button("Exit")
						{
							showingQRCode = false
						}
						.buttonStyle(.borderedProminent)
					}
					.padding()
					.background(.thinMaterial)
					.clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 10, style: .continuous))
					
					
					Image(.contactUs)
						.resizable()
						.scaledToFit()
						.frame(width: 300, height: 300)
						.clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
				}
			}
			
		}
		.padding(.bottom, 80)
	}
	
	#else
	
	var overlay: some View
	{
		VStack
		{
			HStack
			{
				Spacer()
				
				if waterMap
				{
					WaterLevelLegend()
						.padding(.trailing)
						.frame(height: 200)
				}
				
				if showCountryList
				{
					CountriesListView(selected: $selected, countries: vm.allCountries, showCountryList: $showCountryList)
						.frame(width: 160, height: 400)
						.clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 0, topTrailingRadius: 0, style: .continuous))
						.transition(.move(edge: .trailing))
					
				}
			}
			
			
			Spacer()
		}
	}
	
	#endif
}


#Preview
{
	MainMapView()
}

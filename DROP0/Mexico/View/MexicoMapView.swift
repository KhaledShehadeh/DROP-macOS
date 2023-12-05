//
//  MexicoMapView.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 05/12/2023.
//

import SwiftUI
import MapKit

struct MexicoMapView: View 
{
	@StateObject private var vm = VMMexicoMap()
	
//	@State private var position: MapCameraPosition = .automatic
	
	@State private var showingQRCode = false
	
	@State private var selected: ModelMexicoState.Properties?
	
	@State private var showStatesList = false
	@State private var sattelite = false
	@State private var waterMap = false
	
	@State private var slider: Double = 0
	
	private func color(state: ModelMexicoState.Properties) -> Color
	{
		let opacity = 0.8
		if waterMap
		{
			if let waterLevel = state.yearlyAverage?[Int(slider)]
			{
				if waterLevel < 0
				{
					let maxValue = 9.0
					let percent = abs(waterLevel) / maxValue
					return Color.init(hue: 1, saturation: percent, brightness: 1).opacity(opacity)
				}
				else
				{
					let maxValue = 9.0
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
			if selected == state
			{
				return Color.black.opacity(opacity)
			}
			return Color.init(red: 0.69, green: 0.03, blue: 0.22)
		}
	}
	
	var body: some View
	{
		Map(selection: $selected)
		{
			ForEach(vm.states)
			{
				state in
				
				if let coordinates = state.geometry.coordinates
				{
					
					ForEach(coordinates, id: \.first?.latitude)
					{
						coordinate in
						
						MapPolygon(coordinates: coordinate)
							.foregroundStyle(color(state: state.properties))
					}
					
					if !waterMap
					{
						
						Marker(state.properties.name, image: "Mexican_hat", coordinate: coordinates[0][0])
							.tint(selected == state.properties ?
								  Color.white :
									Color.init(red: 0, green: 0.408, blue: 0.28))
							.tag(state.properties)
					}
					else if sattelite
					{
						Annotation(state.properties.name, coordinate: coordinates[0][0])
						{
							VStack
							{
								
							}
						}
						.tag(state.properties)
					}
					
				}
				
			}
			
		}
		.mapStyle(sattelite ? .imagery(elevation: .realistic) : .standard)
		.mapControls {
			MapCompass()
			MapZoomStepper()
				.controlSize(.extraLarge)
		}
		.mapControlVisibility(.visible)
		.safeAreaInset(edge: .top, alignment: .leading) {
			
			VStack(alignment: .leading)
			{
				HStack
				{
					Image("Droplogo2")
						.resizable()
						.scaledToFit()
						.frame(height: 100)
					
					Rectangle()
						.frame(width: 2)
						.padding(.vertical)
					
					Image(.nsstcLogo)
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
				
				Image(.mexicoFlagMap)
					.resizable()
					.scaledToFit()
					.frame(height: 100)
					.padding(.leading)
				
			}
		}
		.overlay {
			overlay
		}
		
	}
}

extension MexicoMapView
{
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
						MexicoStateInfo(state: selected, selectedState: $selected)
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
					
					if showStatesList
					{
						MexicoStatesList(selected: $selected, states: vm.states, showStateList: $showStatesList)
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
					
					TabBar(showCountriesList: $showStatesList, sattelite: $sattelite, waterMap: $waterMap, slider: $slider)
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
	
}

#Preview {
    MexicoMapView()
}

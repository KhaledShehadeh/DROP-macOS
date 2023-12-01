//
//  TabBar.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 23/11/2023.
//

import SwiftUI

struct TabBar: View 
{
	@Binding var showCountriesList: Bool
	@Binding var sattelite: Bool
	@Binding var waterMap: Bool
	@Binding var slider: Double
	
	#if os(macOS)
	
	var body: some View
	{
		VStack(spacing: 50)
		{
			
			HStack(spacing: 30)
			{
				if waterMap
				{
					//					VStack(alignment: .leading, spacing: 20)
					//					{
					//						
					//						Text("Year \(String(Int(slider + 2002)))")
					//							.font(.title2)
					//							.bold()
					//						Slider(value: $slider, in: 0...20, step: 1)
					//					}
					
					Button(role: .cancel)
					{
						//					withAnimation(.easeInOut)
						//					{
						waterMap = false
						showCountriesList = false
						//					}
					} label: {
						Label("Exit", systemImage: "x.circle")
							.padding()
					}
					.buttonStyle(.borderedProminent)
				}
				else
				{
					Button
					{
						//					withAnimation(.easeInOut)
						//					{
						waterMap = true
						showCountriesList = false
						//					}
					} label: {
						Label("Water View", systemImage: "drop")
							.padding()
					}
					.buttonStyle(.borderedProminent)
					.tint(.cyan)
				}
				
				
			}
			
			Button
			{
				//				withAnimation
				//				{
				sattelite.toggle()
				//				}
			} label: {
				if sattelite
				{
					Label("Map View", systemImage: "map")
						.padding()
				}
				else
				{
					Label("Globe View", systemImage: "globe")
						.padding()
				}
			}
			.buttonStyle(.borderedProminent)
			
			Button
			{
				//					withAnimation(.easeInOut)
				//					{
				showCountriesList.toggle()
				//					}
			} label: {
				if showCountriesList
				{
					Label("Exit", systemImage: "x.circle")
						.padding()
				}
				else
				{
					Label("All Countries", systemImage: "line.3.horizontal")
						.padding()
				}
			}
			.buttonStyle(.borderedProminent)
//			.disabled(waterMap)
			
		}
		.font(.title)
		
		
	}
	
	#else
	
	var body: some View
	{
		HStack(spacing: 15)
		{
			Image("Droplogo")
				.resizable()
				.scaledToFit()
				.frame(height: 60)
			
			Spacer()
			
			if waterMap
			{
				VStack(spacing: 0)
				{
					
					Text("Year \(String(Int(slider + 2002)))")
						.font(.caption)
						.bold()
					Slider(value: $slider, in: 0...20, step: 1)
				}
			}
			
			Button
			{
				withAnimation(.easeInOut)
				{
					waterMap.toggle()
					showCountriesList = false
				}
			} label: {
				if waterMap
				{
					Image(systemName: "x.circle")
				}
				else
				{
					Image(systemName: "drop")
				}
			}
			.buttonStyle(.bordered)
			
			Button
			{
				withAnimation
				{
					sattelite.toggle()
				}
			} label: {
				if sattelite
				{
					Image(systemName: "map")
				}
				else
				{
					Image(systemName: "globe")
				}
			}
			.buttonStyle(.bordered)
			
			Spacer()
			
			if !waterMap
			{
				Button
				{
					withAnimation(.easeInOut)
					{
						showCountriesList.toggle()
					}
				} label: {
					if showCountriesList
					{
						Image(systemName: "x.circle")
					}
					else
					{
						Image(systemName: "line.3.horizontal")
					}
				}
				.buttonStyle(.bordered)
			}
		}
		
		
	}
	
	#endif
}

#Preview(traits: .sizeThatFitsLayout)
{
	#if os(macOS)
	TabBar(showCountriesList: .constant(false), sattelite: .constant(false), waterMap: .constant(true), slider: .constant(0))
		.frame(width: 400, height: 1000)
	#else
	TabBar(showCountriesList: .constant(false), sattelite: .constant(false), waterMap: .constant(false), slider: .constant(0))
		.padding(.vertical, 50)
		.padding(.horizontal, 300)
		.background(.thinMaterial)
	#endif
}

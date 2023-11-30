//
//  WaterLevelLegend.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 24/11/2023.
//

import SwiftUI

struct WaterLevelLegend: View 
{
	var body: some View
	{
		HStack(spacing: 0)
		{
			VStack(spacing: 0)
			{
				UnevenRoundedRectangle(topLeadingRadius: .infinity, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: .infinity, style: .circular)
					.fill(
						LinearGradient(gradient: Gradient(colors: [Color.init(hue: 0.6, saturation: 1, brightness: 1), Color.white]),
									   startPoint: .top,
									   endPoint: .bottom))
					.frame(width: 10)
				
				UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: .infinity, bottomTrailingRadius: .infinity, topTrailingRadius: 0, style: .circular)
					.fill(
						LinearGradient(gradient: Gradient(colors: [Color.init(hue: 0.97, saturation: 1, brightness: 1), Color.white]),
									   startPoint: .bottom,
									   endPoint: .top))
					.frame(width: 10)
				
			}
			.overlay {
				RoundedRectangle(cornerRadius: .infinity, style: .circular)
					.stroke(lineWidth: 0.5)
			}
			
			VStack(alignment: .leading)
			{
				HStack
				{
					Rectangle()
						.frame(width: 10, height: 2)
					
					Text("20")
						.frame(width: 30)
				}
				Spacer()
				HStack
				{
					Rectangle()
						.frame(width: 10, height: 2)
					
					Text("10")
						.frame(width: 30)
				}
				Spacer()
				HStack
				{
					Rectangle()
						.frame(width: 10, height: 2)
					
					Text("0")
						.frame(width: 30)
				}
				Spacer()
				HStack
				{
					Rectangle()
						.frame(width: 10, height: 2)
					
					Text("-10")
						.frame(width: 30)
				}
				Spacer()
				HStack
				{
					Rectangle()
						.frame(width: 10, height: 2)
					
					Text("-20")
						.frame(width: 30)
				}
			}
			.bold()
			.foregroundStyle(.white)
		}
	}
}



#Preview
{
    WaterLevelLegend()
		.background(Color.black)
}

//
//  MainView.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 05/12/2023.
//

import SwiftUI

struct MainView: View 
{
	@State private var showAll = true
	
	var body: some View
	{
		if showAll
		{
			MainMapView()
				.overlay
			{
				overlay(label: "MX")
			}
			
		}
		else
		{
			MexicoMapView()
				.overlay
			{
				overlay(label: "BACK")
			}
		}
	}
}

extension MainView
{
	func overlay(label: String) -> some View
	{
		VStack
		{
			HStack
			{
				Spacer()
				
				Button(label)
				{
					showAll.toggle()
				}
			}
			Spacer()
		}
		.ignoresSafeArea()
//		.padding()
	}
}



#Preview 
{
	MainView()
}

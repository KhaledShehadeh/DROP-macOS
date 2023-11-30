//
//  colortest.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 24/11/2023.
//

import SwiftUI

struct colortest: View 
{
	@State private var slider0: Double = 0
    var body: some View
	{
		ZStack
		{
			Color.init(hue: 0.97, saturation: 1, brightness: 1)
		}
    }
}

#Preview {
    colortest()
}

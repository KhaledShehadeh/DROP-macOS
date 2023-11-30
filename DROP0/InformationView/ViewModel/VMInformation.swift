//
//  VMInformation.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 23/11/2023.
//

import Foundation



final class VMInformation: ObservableObject
{
	let yearlyData: [Double]?
	
	let monthlyData: [Double?]?
	
	let country: ModelCountry.Properties
	
	init(country: ModelCountry.Properties)
	{
		self.country = country
		self.yearlyData = country.yearlyAverage
		self.monthlyData = country.monthlyAverage
	}
	
}

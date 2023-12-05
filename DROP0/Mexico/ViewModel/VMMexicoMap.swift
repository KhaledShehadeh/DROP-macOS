//
//  VMMexicoMap.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 05/12/2023.
//

import Foundation



import OSLog


final class VMMexicoMap: ObservableObject
{
	@Published private(set) var states: [ModelMexicoState] = []
	
	init()
	{
		loadJson()
	}
	
	private let logger = Logger()
	
	private func loadJson()
	{
		if let url = Bundle.main.url(forResource: "mexican-states_geo", withExtension: "json")
		{
			do
			{
				let data = try Data(contentsOf: url)
				let decoder = JSONDecoder()
				let jsonData = try decoder.decode(ModelMexico.self, from: data)
				
				self.states = jsonData.mexico
				logger.log("JSON decoded \(jsonData.mexico.count) Mexican States")
				
				loadYearlyAverages()
				loadMonthlyAverages()
			}
			catch
			{
				logger.error("Decoding JSON error: \(error.localizedDescription) \(error)")
			}
		}
		else
		{
			logger.error("JSON file not found")
		}
	}
	
	private func loadYearlyAverages()
	{
		func loadYearlyTxt(for countryName: String) -> [Double]?
		{
			let fileName = countryName + "_1_yearly"
			if let path = Bundle.main.path(forResource: fileName, ofType: "txt")
			{
				do
				{
					let content = try String(contentsOfFile: path)
					
					let numbersAsStringArray = content.components(separatedBy: "\r\n")
					
					let numbers = numbersAsStringArray.compactMap { Double($0) }
					
					return numbers
				}
				catch
				{
					logger.error("Decoding yearly average \(error.localizedDescription)")
				}
			}
			else
			{
//				logger.debug("\(countryName) YA not found")
			}
			return nil
		}
		
		var foundContries = [String]()
		var notFoundContries = [String]()
		
		for (index, country) in states.enumerated()
		{
			let name = country.properties.name
			if let averages = loadYearlyTxt(for: name)
			{
				self.states[index].properties.yearlyAverage = averages
				foundContries.append(name)
			}
			else
			{
				notFoundContries.append(name)
			}
		}
		
//		logger.log("Found for \(foundContries.count) Countries: \n \(foundContries.sorted(by: { $0 < $1 }))")
		
		if notFoundContries.count != 0
		{
			logger.warning("Not found for \(notFoundContries.count) Countries: \n \(notFoundContries.sorted(by: { $0 < $1 }))")
		}
		
	}
	
	private func loadMonthlyAverages()
	{
		func loadMonthlyTxt(for stateName: String) -> [Double?]?
		{
			let fileName = stateName + "_1"
			if let path = Bundle.main.path(forResource: fileName, ofType: "txt")
			{
				do
				{
					let content = try String(contentsOfFile: path)
					
					let numbersAsStringArray = content.components(separatedBy: "\r\n")
					
					let numbers: [Double?] = numbersAsStringArray.compactMap { String in
						if String != "NULL"
						{
							return Double(String)
						}
						else
						{
							return nil
						}
					}
					
					return numbers
				}
				catch
				{
					logger.error("Decoding monthly average \(error.localizedDescription)")
				}
			}
			else
			{
//				logger.debug("\(stateName) MA not found")
			}
			return nil
		}
		
		var foundContries = [String]()
		var notFoundContries = [String]()
		
		for (index, country) in states.enumerated()
		{
			let name = country.properties.name
			if let averages = loadMonthlyTxt(for: name)
			{
				self.states[index].properties.monthlyAverage = averages
				foundContries.append(name)
			}
			else
			{
				notFoundContries.append(name)
			}
		}
		
//		logger.log("Found for \(foundContries.count) State: \n \(foundContries.sorted(by: { $0 < $1 }))")
		
		if notFoundContries.count != 0
		{
			logger.warning("Not found for \(notFoundContries.count) State: \n \(notFoundContries.sorted(by: { $0 < $1 }))")
		}
		
	}
	
}

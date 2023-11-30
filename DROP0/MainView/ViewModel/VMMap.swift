//
//  VMMap.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 23/11/2023.
//

import Foundation
import OSLog


final class VMMap: ObservableObject
{
	@Published private(set) var allCountries: [ModelCountry] = []
	
	init()
	{
		loadJson()
	}
	
	private let logger = Logger()
	
	private func loadJson()
	{
		if let url = Bundle.main.url(forResource: "Africa_Boundaries", withExtension: "json")
		{
			do
			{
				let data = try Data(contentsOf: url)
				let decoder = JSONDecoder()
				let jsonData = try decoder.decode(ModelGeoJsonFile.self, from: data)
				
				self.allCountries = jsonData.countries
				logger.log("JSON decoded \(jsonData.countries.count) countries")
				
				loadYearlyAverages()
				loadMonthlyAverages()
			}
			catch
			{
				logger.error("Decoding JSON error: \(error.localizedDescription)")
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
			let fileName = "y_" + countryName + "_0"
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
				logger.debug("\(countryName) YA not found")
			}
			return nil
		}
		
		var foundContries = [String]()
		var notFoundContries = [String]()
		
		for (index, country) in allCountries.enumerated()
		{
			let name = country.properties.name
			if let averages = loadYearlyTxt(for: name)
			{
				self.allCountries[index].properties.yearlyAverage = averages
				foundContries.append(name)
			}
			else
			{
				notFoundContries.append(name)
			}
		}
		
//		logger.log("Found for \(foundContries.count) Countries: \n \(foundContries.sorted(by: { $0 < $1 }))")
		
//		logger.warning("Not found for \(notFoundContries.count) Countries: \n \(notFoundContries.sorted(by: { $0 < $1 }))")
		
	}
	
	private func loadMonthlyAverages()
	{
		func loadMonthlyTxt(for countryName: String) -> [Double?]?
		{
			let fileName = countryName + "_0"
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
				logger.debug("\(countryName) MA not found")
			}
			return nil
		}
		
		var foundContries = [String]()
		var notFoundContries = [String]()
		
		for (index, country) in allCountries.enumerated()
		{
			let name = country.properties.name
			if let averages = loadMonthlyTxt(for: name)
			{
				self.allCountries[index].properties.monthlyAverage = averages
				foundContries.append(name)
			}
			else
			{
				notFoundContries.append(name)
			}
		}
		
//		logger.log("Found for \(foundContries.count) Countries: \n \(foundContries.sorted(by: { $0 < $1 }))")
		
//		logger.warning("Not found for \(notFoundContries.count) Countries: \n \(notFoundContries.sorted(by: { $0 < $1 }))")
		
	}
	
}

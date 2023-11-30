//
//  ModelCountry.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 23/11/2023.
//

import Foundation
import SwiftUI


import Foundation
import CoreLocation



struct ModelGeoJsonFile: Decodable
{
	let countries: [ModelCountry]
	
	enum CodingKeys: String, CodingKey
	{
		case countries = "features"
	}
}

struct ModelCountry: Identifiable, Decodable
{
	let id: String
	let geometry: Geometry
	var properties: Properties
	
	
	enum CodingKeys: CodingKey
	{
		case geometry
		case properties
	}
	
	init(geometry: Geometry, properties: Properties) 
	{
		self.id = UUID().uuidString
		self.geometry = geometry
		self.properties = properties
	}
	
	init(from decoder: Decoder) throws 
	{
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = UUID().uuidString
		self.geometry = try container.decode(ModelCountry.Geometry.self, forKey: .geometry)
		self.properties = try container.decode(ModelCountry.Properties.self, forKey: .properties)
	}
	
	struct Properties: Decodable, Hashable
	{
		let name: String
		let symbol: String
		let region: AfricaRegions
		
		var yearlyAverage: [Double]?
		var monthlyAverage: [Double?]?
		
		enum CodingKeys: String, CodingKey
		{
			case name = "NAME_0"
			case symbol = "ISO"
			case region = "REgion"
			case yearlyAverage
			case monthlyAverage
		}
		
		init(name: String, symbol: String, region: AfricaRegions)
		{
			self.name = name
			self.symbol = symbol
			self.region = region
			self.yearlyAverage = nil
			self.monthlyAverage = nil
		}
		
		init(from decoder: Decoder) throws
		{
			let container: KeyedDecodingContainer<ModelCountry.Properties.CodingKeys> = try decoder.container(keyedBy: ModelCountry.Properties.CodingKeys.self)
			self.name = try container.decode(String.self, forKey: ModelCountry.Properties.CodingKeys.name)
			self.symbol = try container.decode(String.self, forKey: ModelCountry.Properties.CodingKeys.symbol)
			self.region = try container.decode(AfricaRegions.self, forKey: ModelCountry.Properties.CodingKeys.region)
			
			self.yearlyAverage = nil
			self.monthlyAverage = nil
		}
		
	}
	
	
	struct Geometry: Decodable
	{
		let type: CoordinateTypes
		let coordinates: [[CLLocationCoordinate2D]]?
		
		enum CoordinateTypes: String, Decodable
		{
			case MultiPolygon
			case Polygon
		}
		
		enum CodingKeys: String, CodingKey
		{
			case type
			case coordinates
		}
		
		init(from decoder: Decoder) throws
		{
			let container = try decoder.container(keyedBy: CodingKeys.self)
			
			self.type = try container.decode(CoordinateTypes.self, forKey: .type)
			
			if type == .Polygon
			{
				let coordinates = try container.decode([[[Double]]].self, forKey: .coordinates).first
				var cord: [CLLocationCoordinate2D] = []
				
				
				if let coordinates = coordinates
				{
					for a in coordinates
					{
						let x = CLLocationCoordinate2D(latitude: a[1], longitude: a[0])
						cord.append(x)
					}
				}
				self.coordinates = [cord]
			}
			else
			{
				let coordinates = try container.decode([[[[Double]]]].self, forKey: .coordinates)
				var cords: [[CLLocationCoordinate2D]] = []
				
				for a in coordinates
				{
					var cord: [CLLocationCoordinate2D] = []
					for b in a[0]
					{
						let x = CLLocationCoordinate2D(latitude: b[1], longitude: b[0])
						cord.append(x)
					}
					cords.append(cord)
				}
				self.coordinates = cords
			}
		}
		
	}
	

}

enum AfricaRegions: String, Decodable
{
	case Northern
	case Eastern
	case Central
	case Western
	case Southern
	
	
	var color: Color
	{
		switch self
		{
			case .Northern: return .purple
			case .Southern: return .red
			case .Central: return .orange
			case .Eastern: return .gray
			case .Western: return .yellow
		}
	}
}




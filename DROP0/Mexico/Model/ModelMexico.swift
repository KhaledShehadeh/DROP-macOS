//
//  ModelMexico.swift
//  DROP0
//
//  Created by Khaled Shehadeh on 05/12/2023.
//

import Foundation
import CoreLocation



struct ModelMexico: Decodable
{
	let mexico: [ModelMexicoState]
	
	enum CodingKeys: String, CodingKey
	{
		case mexico = "features"
	}
}

struct ModelMexicoState: Identifiable, Decodable
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
		self.geometry = try container.decode(ModelMexicoState.Geometry.self, forKey: .geometry)
		self.properties = try container.decode(ModelMexicoState.Properties.self, forKey: .properties)
	}
	
	struct Properties: Decodable, Hashable
	{
		let name: String
		
		var yearlyAverage: [Double]?
		var monthlyAverage: [Double?]?
		
		enum CodingKeys: String, CodingKey
		{
			case name
			case yearlyAverage
			case monthlyAverage
		}
		
		init(name: String)
		{
			self.name = name
			
			self.yearlyAverage = nil
			self.monthlyAverage = nil
		}
		
		init(from decoder: Decoder) throws
		{
			let container: KeyedDecodingContainer<ModelMexicoState.Properties.CodingKeys> = try decoder.container(keyedBy: ModelMexicoState.Properties.CodingKeys.self)
			self.name = try container.decode(String.self, forKey: ModelMexicoState.Properties.CodingKeys.name)
			
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




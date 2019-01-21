//
//  Person.swift
//  Holocron
//
//  Created by Alex Agapov on 16/01/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import Foundation

enum Gender: String, Codable {
    case male
    case female
}

struct Person: Codable {
    let birthYear: String

    let eyeColor: String?
    let gender: Gender?
    let hairColor: String?

    let mass: String
    let height: String
    let homeworld: String
    let name: String
    let skinColor: String
    let created: Date? // ISO 8601
    let edited: Date? // ISO 8601
    let url: URL
    let films: [URL]
    let species: [URL]
    let starships: [URL]
    let vehicles: [URL]

    enum CodingKeys: String, CodingKey {
        case birthYear = "birth_year"
        case eyeColor = "eye_color"
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case films, gender, height, homeworld, mass, name, species, starships, url, vehicles, created, edited
    }

    //    func encode(to encoder: Encoder) throws {
    //        var container = encoder.container(keyedBy: CodingKeys.self)
    //        try container.encode(title, forKey: .title)
    //        try container.encode(price, forKey: .price)
    //        try container.encode(quantity, forKey: .quantity)
    //    }

    // Added because of unknown and n\a in gender, eye_color, hair_color
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        birthYear = try container.decode(String.self, forKey: .birthYear)

        func decode<T>(value: T?) -> T? {
            if let value = value {
                if let stringValue = value as? String, stringValue == "unknown" || stringValue == "n/a" {
                    return nil
                } else {
                    return value
                }
            } else {
                return nil
            }
        }
        eyeColor = decode(value: try? container.decode(String.self, forKey: .eyeColor))
        gender = decode(value: try? container.decode(Gender.self, forKey: .gender))
        hairColor = decode(value: try? container.decode(String.self, forKey: .hairColor))

        mass = try container.decode(String.self, forKey: .mass)
        height = try container.decode(String.self, forKey: .height)
        homeworld = try container.decode(String.self, forKey: .homeworld)
        name = try container.decode(String.self, forKey: .name)
        skinColor = try container.decode(String.self, forKey: .skinColor)
        created = try? container.decode(Date.self, forKey: .created)
        edited = try? container.decode(Date.self, forKey: .edited)
        url = try container.decode(URL.self, forKey: .url)
        films = try container.decode([URL].self, forKey: .films)
        species = try container.decode([URL].self, forKey: .species)
        starships = try container.decode([URL].self, forKey: .starships)
        vehicles = try container.decode([URL].self, forKey: .vehicles)
    }
}

extension Person {
    static var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

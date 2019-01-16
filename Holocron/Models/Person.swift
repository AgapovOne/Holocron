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
    case unknown
}

struct Person: Codable {
    let name: String
//    let birth_year: String
//    eye_color string -- The eye color of this person. Will be "unknown" if not known or "n/a" if the person does not have an eye.
//    gender string -- The gender of this person. Either "Male", "Female" or "unknown", "n/a" if the person does not have a gender.
//    hair_color string -- The hair color of this person. Will be "unknown" if not known or "n/a" if the person does not have hair.
//    height string -- The height of the person in centimeters.
//    mass string -- The mass of the person in kilograms.
//    skin_color string -- The skin color of this person.
//    homeworld string -- The URL of a planet resource, a planet that this person was born on or inhabits.
//    films array -- An array of film resource URLs that this person has been in.
//    species array -- An array of species resource URLs that this person belongs to.
//    starships array -- An array of starship resource URLs that this person has piloted.
//    vehicles array -- An array of vehicle resource URLs that this person has piloted.
    let url: URL
//    created string -- the ISO 8601 date format of the time that this resource was created.
//    edited string
}

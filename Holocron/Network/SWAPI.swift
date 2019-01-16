//
//  SWAPI.swift
//  Holocron
//
//  Created by Alex Agapov on 16/01/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import Moya

enum SWAPI {
    case person(id: Int)
    case people(search: String?)
}

extension SWAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://swapi.co/api")!
    }

    var path: String {
        switch self {
        case .person(let id):
            return "/people/\(id)"
        case .people:
            return "/people"
        }
    }

    var method: Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .person:
            return .requestPlain
        case .people(search: let search):
            if let parameters = search?.notEmpty.map({ ["search": $0] }) {
                return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            } else {
                return .requestPlain
            }
        }
    }

    var headers: [String : String]? {
        return nil
    }
}

private extension String {
    var notEmpty: String? {
        return self.isEmpty ? nil : self
    }
}

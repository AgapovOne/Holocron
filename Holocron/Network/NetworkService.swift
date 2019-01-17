//
//  NetworkService.swift
//  Holocron
//
//  Created by Alex Agapov on 16/01/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import Moya
import RxSwift

enum NetworkService {

    static let provider: MoyaProvider<SWAPI> = {
        let plugin = NetworkActivityPlugin(networkActivityClosure: { (change, _) in
            switch change {
            case .began:
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .ended:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        })
        return MoyaProvider<SWAPI>(plugins: [plugin])
    }()

    static func getPeople(name: String? = nil) -> Single<[Person]> {
        return NetworkService.provider.rx
            .request(.people(search: name))
            .filterSuccessfulStatusCodes()
            .map([Person].self, atKeyPath: "results")
    }

    static func getPerson(id: Int) -> Single<Person> {
        return NetworkService.provider.rx
            .request(.person(id: id))
            .filterSuccessfulStatusCodes()
            .map(Person.self)
    }
}

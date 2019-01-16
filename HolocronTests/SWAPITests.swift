//
//  SWAPITests.swift
//  SWAPITests
//
//  Created by Alex Agapov on 16/01/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import XCTest
@testable import Holocron
import RxSwift
import Moya

class SWAPITests: XCTestCase {

    let disposeBag = DisposeBag()
    let provider = MoyaProvider<SWAPI>()

    func testPerformancePeople() {
        let expectation = self.expectation(description: "People request")
        var result: [Person]?
        provider.rx.request(.people(search: "Darth"))
            .map([Person].self, atKeyPath: "results")
            .subscribe {
                switch $0 {
                case .error(let error):
                    XCTFail(error.localizedDescription)
                case .success(let response):
                    result = response
                }
                expectation.fulfill()
            }
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 10, handler: nil)

        print(result)
        XCTAssertNotNil(result)
    }

    func testPerformancePerson() {
        let expectation = self.expectation(description: "Person request")
        var result: Person?
        provider.rx.request(.person(id: 1))
            .map(Person.self)
            .subscribe {
                switch $0 {
                case .error(let error):
                    XCTFail(error.localizedDescription)
                case .success(let response):
                    result = response
                }
                expectation.fulfill()
            }
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 10, handler: nil)

        print(result)
        XCTAssertNotNil(result)
    }
}

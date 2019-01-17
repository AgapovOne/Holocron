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

final class SWAPITests: XCTestCase {

    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<SWAPI>()

    func testPeopleAPIRequest() {
        let expectation = self.expectation(description: "People request")
        var result: [Person]?
        provider.rx.request(.people(search: ""))
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

        XCTAssertNotNil(result)
        XCTAssertFalse(result!.isEmpty)
    }

    func testPersonAPIRequest() {
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

        XCTAssertNotNil(result)
        XCTAssertEqual(result!.name, "Luke Skywalker")
    }
}

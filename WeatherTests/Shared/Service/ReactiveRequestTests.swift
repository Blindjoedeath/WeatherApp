//
//  ReactiveRequestTests.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 21/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
import RxSwift
@testable import Weather

class ReactiveRequestTests: XCTestCase {
    
    var bag = DisposeBag()
    
    override func setUp() {
    }

    override func tearDown() {
    }

    func testReactiveRequestShouldErrorWhenWrongUrl() {
        let fakeUrl = URL(string: "http://")!
        let request = ReactiveRequest<Weather>.create(for: fakeUrl)
        
        let expect = expectation(description: "Expect error to emit")
        
        request
            .subscribe(
                onError:{ error in
                    XCTAssertNotNil(error)
                    expect.fulfill()
            }).disposed(by: bag)
        
        waitForExpectations(timeout: 1){error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
}

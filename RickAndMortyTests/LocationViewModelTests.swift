//
//  LocationViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Diggo Silva on 29/09/25.
//

import XCTest
import Combine
@testable import RickAndMorty

final class LocationViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super .setUp()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testIfLoadLocationsSuccess() async {
        let mockService = MockService()
        let sut = LocationViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        var receivedStates: [LocationViewControllerStates] = []
        
        sut.statePublisher.sink { state in
            receivedStates.append(state)
            if state == .loaded {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.fetchLocations()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        let lastLocation = sut.location(at: IndexPath(row: 1, section: 0))
        
        XCTAssertEqual(receivedStates, [.loading, .loaded])
        XCTAssertEqual(sut.numberOfRows(), 2)
        XCTAssertEqual(lastLocation.location.name, "Mars")
    }
    
    func testIfHaMorePages() async {
        let mockService = MockService()
        mockService.shouldReturnEmpty = true
        let sut = LocationViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        var receivedStates: [LocationViewControllerStates] = []
        
        sut.statePublisher.sink { state in
            receivedStates.append(state)
            if state == .loaded {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.fetchLocations()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        XCTAssertEqual(sut.numberOfRows(), 0)
    }
    
    func testLoadLocationFail() async {
        let mockService = MockService()
        mockService.isSuccess = false
        let sut = LocationViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "State deveria ser .error")
        var receivedStates: [LocationViewControllerStates] = []
        
        sut.statePublisher.sink { state in
            receivedStates.append(state)
            if state == .error {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.fetchLocations()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        XCTAssertEqual(sut.numberOfRows(), 0)
    }
    
    func testResidentsAreAppendedToLocation() async {
        let mockService = MockService()
        mockService.shouldReturnMatchingResidents = true
        
        let sut = LocationViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "State should be .loaded")
        
        sut.statePublisher.sink { state in
            if state == .loaded {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.fetchLocations()
        await fulfillment(of: [expectation], timeout: 0.1)
        
        XCTAssertEqual(sut.numberOfRows(), 1)
        
        let locationChar = sut.location(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(locationChar.location.name, "Earth")
        XCTAssertEqual(locationChar.chars.count, 1)
        XCTAssertEqual(locationChar.chars.first?.name, "Rick Sanchez")
    }
}

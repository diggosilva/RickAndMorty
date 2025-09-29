//
//  DetailsViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Diggo Silva on 28/09/25.
//

import XCTest
import Combine
@testable import RickAndMorty

final class DetailsViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    let char = Char(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", type: "", gender: "Male", origin: CharLocation(name: "Earth", url: ""), location: CharLocation(name: "", url: ""), image: "photo.jpg", episodes: [], url: "", created: "")
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testIfLoadItemsInCollectionview() async {
        let mockService = MockService()
        let sut = DetailsViewModel(char: char, service: mockService)
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        var receivedStates: [DetailsViewControllerStates] = []
        
        sut.statePublisher.sink { state in
            receivedStates.append(state)
            if state == .loaded {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.fetchEpisodes()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        let name = sut.name
        let status = sut.status
        let gender = sut.gender
        let origin = sut.origin
        let species = sut.species
        let imageURL = sut.imageURL
        let firstItem = sut.infoItem(at: IndexPath(row: 3, section: 0))
        
        XCTAssertEqual(receivedStates.last, .loaded)
        XCTAssertEqual(name, "Rick Sanchez")
        XCTAssertEqual(status, "Alive")
        XCTAssertEqual(gender, "Male")
        XCTAssertEqual(origin, "Earth")
        XCTAssertEqual(species, "Human")
        XCTAssertEqual(imageURL, "photo.jpg")
        XCTAssertEqual(sut.numberOfInfoItems(), 4)
        XCTAssertEqual(firstItem.title, "Origem")
    }
    
    func testLoadEpisodesInTableViewSuccess() async {
        let mockService = MockService()
        let sut = DetailsViewModel(char: char, service: mockService)
        
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        var receivedStates: [DetailsViewControllerStates] = []
        
        sut.statePublisher.sink { state in
            receivedStates.append(state)
            if state == .loaded {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.fetchEpisodes()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        let firstEpisode = sut.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(receivedStates.last, .loaded)
        XCTAssertEqual(sut.numberOfRows(), 2)
        XCTAssertEqual(firstEpisode.name, "Pilot")
    }
    
    func testLoadEpisodesInTableViewFail() async {
        let mockService = MockService()
        mockService.isSuccess = false
        let sut = DetailsViewModel(char: char, service: mockService)
        let expectation = XCTestExpectation(description: "Status deveria ser .error")
        var receivedStates: [DetailsViewControllerStates] = []
        
        sut.statePublisher.sink { state in
            receivedStates.append(state)
            if state == .error {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.fetchEpisodes()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        XCTAssertEqual(sut.numberOfRows(), 0)
        XCTAssertEqual(receivedStates.last, .error)
    }
}

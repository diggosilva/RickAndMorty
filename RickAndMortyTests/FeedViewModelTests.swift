//
//  FeedViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Diggo Silva on 26/09/25.
//

import XCTest
import Combine
@testable import RickAndMorty

final class FeedViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFetchCharacters_Success_ShouldLoadCharacters() async {
        let mockService = MockService()
        let sut = FeedViewModel(service: mockService)
        
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        var receivedStates: [FeedViewControllerStates] = []
        
        sut.statePublisher
            .sink { state in
                receivedStates.append(state)
                if state == .loaded {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.fetchCharacters()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        XCTAssertEqual(receivedStates.last, .loaded)
        XCTAssertEqual(sut.numberOfItems(), 2)
    }
    
    func testFetchCharacters_Failure_ShouldEmitError() async {
        let mockService = MockService()
        mockService.isSuccess = false
        let sut = FeedViewModel(service: mockService)
        
        let expectation = XCTestExpectation(description: "State deveria ser .error")
        var receivedStates: [FeedViewControllerStates] = []
        
        sut.statePublisher
            .sink { state in
                receivedStates.append(state)
                if state == .error {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.fetchCharacters()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        XCTAssertEqual(receivedStates.last, .error)
        XCTAssertEqual(sut.numberOfItems(), 0)
    }
    
    func testSearchBarTextDidChange_ShouldFilterCharacters() async {
        let mockService = MockService()
        let sut = FeedViewModel(service: mockService)
        
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        var receivedStates: [FeedViewControllerStates] = []
        
        sut.statePublisher
            .sink { state in
                receivedStates.append(state)
                if state == .loaded {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.fetchCharacters()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        // Confirmando estado inicial
        XCTAssertEqual(sut.numberOfItems(), 2)
        
        let name = sut.character(at: IndexPath(row: 1, section: 0)).name
        XCTAssertEqual(name, "Morty Smith")
        
        // Filtrar por Rick
        sut.searchBarTextDidChange(searchText: "Rick")
        XCTAssertEqual(sut.numberOfItems(), 1)
        XCTAssertEqual(sut.currentCharacters().first?.name, "Rick Sanchez")
        
        // Filtrar por status
        sut.searchBarTextDidChange(searchText: "dead")
        XCTAssertEqual(sut.numberOfItems(), 0)
    }
    
    func testPagination_ShouldRespectHasMorePages() async {
        let mockService = MockService()
        mockService.shouldReturnEmpty = true // Simula que não há mais páginas
        let sut = FeedViewModel(service: mockService)
        
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        var receivedStates: [FeedViewControllerStates] = []
        
        sut.statePublisher
            .sink { state in
                receivedStates.append(state)
                if state == .loaded {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.fetchCharacters()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        XCTAssertEqual(sut.numberOfItems(), 0)
        
        sut.fetchCharacters()
        XCTAssertEqual(sut.numberOfItems(), 0)
    }
}

//
//  FeedViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Diggo Silva on 26/09/25.
//

import XCTest
import Combine
@testable import RickAndMorty

final class RickAndMortyTests: XCTestCase {
    
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
        let viewModel = FeedViewModel(service: mockService)
        
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        var receivedStates: [FeedViewControllerStates] = []
        
        viewModel.statePublisher
            .sink { state in
                receivedStates.append(state)
                if state == .loaded {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        viewModel.fetchCharacters()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertEqual(receivedStates.last, .loaded)
        XCTAssertEqual(viewModel.numberOfItems(), 2)
    }
    
    func testFetchCharacters_Failure_ShouldEmitError() async {
        let mockService = MockService()
        mockService.isSuccess = false
        let viewModel = FeedViewModel(service: mockService)
        
        let expectation = XCTestExpectation(description: "State deveria ser .error")
        var receivedStates: [FeedViewControllerStates] = []
        
        viewModel.statePublisher
            .sink { state in
                receivedStates.append(state)
                if state == .error {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        viewModel.fetchCharacters()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertEqual(receivedStates.last, .error)
        XCTAssertEqual(viewModel.numberOfItems(), 0)
    }
    
    func testSearchBarTextDidChange_ShouldFilterCharacters() async {
        let mockService = MockService()
        let viewModel = FeedViewModel(service: mockService)
        
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        var receivedStates: [FeedViewControllerStates] = []
        
        viewModel.statePublisher
            .sink { state in
                receivedStates.append(state)
                if state == .loaded {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        viewModel.fetchCharacters()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Confirmando estado inicial
        XCTAssertEqual(viewModel.numberOfItems(), 2)
        
        let name = viewModel.character(at: IndexPath(row: 1, section: 0)).name
        XCTAssertEqual(name, "Morty Smith")
        
        // Filtrar por Rick
        viewModel.searchBarTextDidChange(searchText: "Rick")
        XCTAssertEqual(viewModel.numberOfItems(), 1)
        XCTAssertEqual(viewModel.currentCharacters().first?.name, "Rick Sanchez")
        
        // Filtrar por status
        viewModel.searchBarTextDidChange(searchText: "dead")
        XCTAssertEqual(viewModel.numberOfItems(), 0)
    }
    
    func testPagination_ShouldRespectHasMorePages() async {
        let mockService = MockService()
        mockService.shouldReturnEmpty = true // Simula que não há mais páginas
        let viewModel = FeedViewModel(service: mockService)
        
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        var receivedStates: [FeedViewControllerStates] = []
        
        viewModel.statePublisher
            .sink { state in
                receivedStates.append(state)
                if state == .loaded {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        viewModel.fetchCharacters()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModel.numberOfItems(), 0)
        
        viewModel.fetchCharacters()
        XCTAssertEqual(viewModel.numberOfItems(), 0)
    }
}

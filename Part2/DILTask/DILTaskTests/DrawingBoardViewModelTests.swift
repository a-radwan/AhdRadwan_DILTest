//
//  DrawingBoardViewModelTests.swift
//  DILTaskTests
//
//  Created by Ahd on 9/10/23.
//
import XCTest
@testable import DILTask

class DrawingBoardViewModelTests: XCTestCase {
    
    var viewModel: DrawingBoardViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = DrawingBoardViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testSetColor() {
        viewModel.setColor(.red)
        XCTAssertEqual(viewModel.currentColor, .red)
    }
    
    func testGetDrawingDelay() {
        viewModel.setColor(.red)
        XCTAssertEqual(viewModel.getDrawingDelay(), 1.0)
        
        viewModel.setColor(.blue)
        XCTAssertEqual(viewModel.getDrawingDelay(), 3.0)
        
        viewModel.setColor(.green)
        XCTAssertEqual(viewModel.getDrawingDelay(), 5.0)
        
        // Default case
        viewModel.setColor(.yellow)
        XCTAssertEqual(viewModel.getDrawingDelay(), 2.0)
    }
    
    func testCreateGhostLayer() {
        viewModel.addDrawingPoint(CGPoint(x: 10, y: 20))
        viewModel.setColor(.red)
        
        let ghostLayer = viewModel.createGhostLayer()
        XCTAssertNotNil(ghostLayer)
        XCTAssertEqual(ghostLayer?.strokeColor, UIColor.red.cgColor)
        XCTAssertEqual(ghostLayer?.lineWidth, CGFloat(viewModel.kLineWidth))
    }
    
    func testCreateGhostLayerEmptyPoints() {
        viewModel.setColor(.blue)
        
        let ghostLayer = viewModel.createGhostLayer()
        XCTAssertNil(ghostLayer)
    }
}

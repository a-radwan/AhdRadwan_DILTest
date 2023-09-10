//
//  DrawingBoardViewModel.swift
//  DILTask
//
//  Created by Ahd on 9/10/23.
//

import UIKit

class DrawingBoardViewModel {
    
    // MARK: - Constants
    let kLineWidth = 10.0
    
    // MARK: - Properties
    private(set) var currentColor: UIColor = .blue
    private var drawingPoints: [CGPoint] = []
    
    // MARK: - Properties Managment
    
    func setColor(_ color: UIColor) {
        currentColor = color
    }
    
    func addDrawingPoint(_ point: CGPoint) {
        drawingPoints.append(point)
    }
    
    func clearDrawing() {
        drawingPoints.removeAll()
    }
    
    // MARK: - Utils
    
    func getDrawingDelay() -> TimeInterval {
        switch currentColor {
        case .red: return 1.0
        case .blue: return 3.0
        case .green: return 5.0
        default: return 2.0
        }
    }
    
    
    func createGhostLayer() -> CAShapeLayer? {
        guard !drawingPoints.isEmpty else { return nil }
        
        let ghostLayer = CAShapeLayer()
        ghostLayer.strokeColor = currentColor.cgColor
        ghostLayer.fillColor = nil
        ghostLayer.lineWidth = kLineWidth
        
        let path = UIBezierPath()
        path.move(to: drawingPoints.first!)
        
        for point in drawingPoints.dropFirst() {
            path.addLine(to: point)
        }
        
        ghostLayer.path = path.cgPath
        return ghostLayer
    }
}

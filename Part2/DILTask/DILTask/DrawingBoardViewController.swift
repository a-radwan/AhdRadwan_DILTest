//
//  DrawingBoardViewController.swift
//  DILTask
//
//  Created by Ahd on 9/7/23.
//

import UIKit

class DrawingBoardViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var drawingView: UIView!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    
    // MARK: - Properties
    
    private var viewModel = DrawingBoardViewModel()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColoredButtons()
        setupGestureRecognizers()
    }
    
    // MARK: - Setup
    
    private func setupColoredButtons() {
        let buttons = [blueButton, greenButton, redButton]
        
        blueButton.backgroundColor = .blue;
        greenButton.backgroundColor = .green
        redButton.backgroundColor = .red
        
        buttons.forEach { button in
            button?.layer.cornerRadius = (button?.frame.size.width ?? 0) / 2.0
            button?.clipsToBounds = true
        }
    }
    
    private func setupGestureRecognizers() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        drawingView.addGestureRecognizer(panRecognizer)
    }
    
    // MARK: - Gesture Recognizer
    
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: drawingView)
        
        switch recognizer.state {
        case .began:
            viewModel.clearDrawing()
        case .changed:
            viewModel.addDrawingPoint(location)
        case .ended:
            if let ghostLayer = viewModel.createGhostLayer() {
                DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.getDrawingDelay()) { [weak self] in
                    
                    self?.drawingView.layer.addSublayer(ghostLayer)
                    self?.animateGhostDrawing(ghostLayer)
                }
            }
        default:
            break
        }
    }
    
    // MARK: - Drawing
    
    private func animateGhostDrawing(_ ghostLayer: CAShapeLayer) {
       
        let drawDuration = 2.0 // Two seconds.
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = drawDuration
        
        ghostLayer.add(animation, forKey: "strokeAnimation")
    }
    
    // MARK: - Actions
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        if let color = sender.backgroundColor {
            viewModel.setColor(color)
        }
    }
    
    @IBAction func eraserButtonTapped(_ sender: UIButton) {
        viewModel.setColor(drawingView.backgroundColor ?? .white)
    }
    
    @IBAction func clearDrawingArea(_ sender: UIButton) {
        removeAllGhostLayers()
    }
    
    private func removeAllGhostLayers() {
        for sublayer in drawingView.layer.sublayers ?? [] {
            if sublayer is CAShapeLayer {
                sublayer.removeFromSuperlayer()
            }
        }
    }
}


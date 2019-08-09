//
//  ViewController.swift
//  Arena Visualization
//
//  Created by Adwait Dongare on 10/3/18.
//  Copyright © 2018 Adwait Dongare. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var trackingStatusLabel: UILabel!
    
    // MARK: variables
    var annotationObjects: [String:ARAnnotation] = [:]
    var positionUpdateTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.session.delegate = self
        
        // use ARKit debug options: enable feature points and enable showing scene origin
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        setupSampleDevices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        
        // Display current device position and setup timer object to update it periodically
        positionUpdateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updatePositionLabel), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    // called when tracking mode changes
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        let trackingStateString = String(format:"Tracking: \(camera.trackingState)")
        trackingStatusLabel.text = trackingStateString
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // MARK: Actions
    @IBAction func resetTrackingButton(_ sender: UIBarButtonItem) {
        // get default ARKit configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // pause old session and rerun from scratch
        sceneView.session.pause()
        
        // restart tracking session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: Private helper functions
    
    // simple radian to degree conversion
    private func radToDegrees(theta: Float) -> Float {
        return (theta*180)/Float.pi
    }
    
    // updates device position by grabbing the current frame
    @objc private func updatePositionLabel() {
        if let frame = sceneView.session.currentFrame {
            let position = frame.camera.transform.columns.3
            let orientation = frame.camera.eulerAngles
            let positionString = String(format:"ARKit position - x:%.03f, y:%.03f, z:%.03f, alpha:%.03f, beta:%.03f, gamma:%.03f", position.x, position.y, position.z, radToDegrees(theta: orientation.x),radToDegrees(theta: orientation.y), radToDegrees(theta: orientation.z))
            positionLabel.text = positionString
        } else {
            // could not get current frame
            positionLabel.text = "Could not get current ARKit frame"
        }
    }
    
    private func setupSampleDevices() {
        
        // create and add objects to the scene
        annotationObjects["center"] = ARAnnotation(uuid: "center", text: "Welcome to Carnegie Mellon!", root: sceneView.scene.rootNode, position_x: 0, position_y: 0, position_z: -0.5)
        annotationObjects["left"] = ARAnnotation(uuid: "left", text: "This is to the left", root: sceneView.scene.rootNode, position_x: -1.5, position_y: 0, position_z: -0.5)
        annotationObjects["right"] = ARAnnotation(uuid: "right", text: "This is to the right", root: sceneView.scene.rootNode, position_x: 1.5, position_y: 0, position_z: -0.5)
        annotationObjects["ahead"] = ARAnnotation(uuid: "ahead", text: "This is up ahead", root: sceneView.scene.rootNode, position_x: 0, position_y: 0, position_z: -2)
    }
}

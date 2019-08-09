//
//  ARAnnotation.swift
//  Arena Visualization
//
//  AR annotation object
//  Created by Adwait Dongare on 10/3/18.
//  Copyright © 2018 Adwait Dongare. All rights reserved.
//

import Foundation
import ARKit

class ARAnnotation {
    var uuid: String
    var data: String
    private var textObject:SCNText
    private var nodeObject:SCNNode
    
    init(uuid: String, text: String, root: SCNNode, position_x: Float, position_y: Float, position_z: Float) {
        self.uuid = uuid
        self.data = text
        
        // create text object
        self.textObject = SCNText(string: text, extrusionDepth: 1)
        
        // set material properties of text object
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.orange
        self.textObject.materials = [material]
        
        // create node object at proper location and size
        self.nodeObject = SCNNode()
        nodeObject.position = SCNVector3(x:position_x, y:position_y, z:position_z)
        nodeObject.scale = SCNVector3(x:0.008, y:0.008, z:0.008)
        
        // attach text object to node object
        nodeObject.geometry = self.textObject
        
//        // set constrain to point at camera
//        let constrain = SCNBillboardConstraint()
//        constrain.freeAxes = SCNBillboardAxis.Y
//        nodeObject.constraints = [constrain]
        
        // add node to root node
        root.addChildNode(self.nodeObject)
        print("[debug] successfully created object called \(uuid)")
    }
}

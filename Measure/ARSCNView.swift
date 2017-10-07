//
//  ARSCNView.swift
//  Measure
//
//  Created by levantAJ on 8/9/17.
//  Copyright © 2017 levantAJ. All rights reserved.
//

import SceneKit
import ARKit

extension ARSCNView {
    
    func realWorldVector(screenPosition: CGPoint) -> SCNVector3? {
        let resultPosition : SCNVector3?
        (resultPosition, _, _) = self.worldPositionFromScreenPosition(screenPosition, objectPos: nil, infinitePlane: false)
        return resultPosition
    }
    
    func worldPositionFromScreenPosition(_ position: CGPoint, objectPos: SCNVector3?, infinitePlane: Bool = false) -> (position: SCNVector3?, planeAnchor: ARPlaneAnchor?, hitAPlane: Bool) {
        
        let planeHitTestResults = self.hitTest(position, types: .existingPlaneUsingExtent)
        if let result = planeHitTestResults.first {
            let planeHitTestPosition = SCNVector3.positionFromTransform(result.worldTransform)
            let planeAnchor = result.anchor
            // Return immediately - this is the best possible outcome.
            print("NUMBER1:",planeHitTestPosition)
            return (planeHitTestPosition, planeAnchor as? ARPlaneAnchor, true)
        }
        
        var featureHitTestPosition: SCNVector3?
        var highQualityFeatureHitTestResult = false
        let highQualityfeatureHitTestResults = self.hitTestWithFeatures(position, coneOpeningAngleInDegrees: 18, minDistance: 0.5, maxDistance: 4.0)
        if !highQualityfeatureHitTestResults.isEmpty {
            let result = highQualityfeatureHitTestResults[0]
            featureHitTestPosition = SCNVector3(result.position)
            highQualityFeatureHitTestResult = true
        }
        
//        if infinitePlane || !highQualityFeatureHitTestResult {
//            let pointOnPlane = objectPos ?? SCNVector3Zero
//            let pointOnInfinitePlane = self.hitTestWithInfiniteHorizontalPlane(position, float3(pointOnPlane))
//            if pointOnInfinitePlane != nil {
//                return (SCNVector3(pointOnInfinitePlane!) , nil, true)
//            }
//        }
        
        if highQualityFeatureHitTestResult {
            print("NUMBER2:",featureHitTestPosition!)
            return (featureHitTestPosition, nil, false)
        }
        
//        let unfilteredFeatureHitTestResults = self.hitTestWithFeatures(position)
//        if !unfilteredFeatureHitTestResults.isEmpty {
//            let result = unfilteredFeatureHitTestResults[0]
//            print("NUMBER3:",SCNVector3(result.position))
//            return (SCNVector3(result.position), nil, false)
//        }
        
        let finalHitTestResults = self.hitTest(position, types: .featurePoint)
        if let result = finalHitTestResults.first {
            let finalHitTestPosition = SCNVector3.positionFromTransform(result.worldTransform)
            print("NUMBER4:",finalHitTestPosition)
            return (finalHitTestPosition, nil, false)
        }
        
        print("EMPTYEMPTYEMPTY!!!")
        return (nil, nil, false)
    }

}

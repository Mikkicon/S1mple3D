//
//  GameViewController.swift
//  UFOTest
//
//  Created by Mikhail Petrenko on 11/21/18.
//  Copyright © 2018 Mikhail Petrenko. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    //View everything combined
    var gameView:SCNView!
    //Scene is placed on top of view and could change
    var gameScene:SCNScene!
    //Node nodes are objects in game: lighting, geometry objects, etc
    var cameraNode:SCNNode!
    //Interval between something
    var targetCreationTime:TimeInterval = 10
    
    //Main function which is called first
    override func viewDidLoad() {
        //invoke constructor from parent
        super.viewDidLoad()
        initView()
        initScene()
        initCamera()
        
        
        //        createTarget()
        
    }
    func initView(){
        //assign to gameView view from pa t UIViewController
        gameView = self.view as! SCNView
        gameView.allowsCameraControl = true
        gameView.autoenablesDefaultLighting = true
        gameView.delegate = self
    }
    
    func initScene() {
        gameScene = SCNScene()
        gameView.scene = gameScene
        gameView.isPlaying = true
        //        gameScene.rootNode.childNodes
        
    }
    
    func initCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x:0,y:5,z:10)
        gameScene.rootNode.addChildNode(cameraNode)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: gameView)
        let hits = gameView.hitTest(location, options: nil)
        
        if let hitObj = hits.first {
            let node = hitObj.node
            if node.name == "bad"{
                node.removeFromParentNode()
                self.gameView.backgroundColor = UIColor.red
            }else{
                node.removeFromParentNode()
                self.gameView.backgroundColor = UIColor.black
            }
        }
        
    }
    func cleanUp(){
        for node in gameScene.rootNode.childNodes{
            if node.position.y < -2{
                node.removeFromParentNode()
            }
        }
    }
    
    func createTarget(){
        let UFO:SCNGeometry = SCNCylinder(radius: 1, height: 1)
        //        UFO.materials.first?.diffuse.contents = UIColor.blue
        let randomColor = arc4random_uniform(2) == 0 ? UIColor.blue : UIColor.red
        let UFONode = SCNNode(geometry: UFO)
        UFO.materials.first?.diffuse.contents = randomColor
        UFONode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        if randomColor == UIColor.blue {
            UFONode.name = "good"
        } else {
            UFONode.name = "bad"
        }
        gameScene.rootNode.addChildNode(UFONode)
        let _direction:Float = arc4random_uniform(2) == 0 ? -2.0 : 2.0
        let force = SCNVector3(x: _direction, y: 25, z: 0)
        UFONode.physicsBody?.applyForce(force, at: SCNVector3(x: 0.05, y: 0.05, z: 0.05), asImpulse: true)
        UFONode.physicsBody?.applyTorque(SCNVector4(x: 10, y: 0, z: 0, w: 0.1), asImpulse: true)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > targetCreationTime{
            createTarget()
            targetCreationTime = time + 0.6
        }
    }
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}

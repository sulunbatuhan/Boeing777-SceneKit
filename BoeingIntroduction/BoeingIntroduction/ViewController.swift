//
//  ViewController.swift
//  BoeingIntroduction
//
//  Created by batuhan on 31.01.2025.
//

import UIKit
import SceneKit

final class ViewController: UIViewController {
    private var sceneView  : SCNView!
    private var cameraNode = SCNNode()
    private var sphere     = SCNSphere(radius: 10)
    private var sphereNode = SCNNode()
    private var panoramaImage : PanoramaImages = .boarding
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
        sceneView = SCNView(frame: self.view.bounds)
        self.view.addSubview(sceneView)
        let scene = SCNScene()
        sceneView.scene = scene

  
        let camera          = SCNCamera()
        cameraNode.camera   = camera
        cameraNode.name     = "camera"
        cameraNode.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(cameraNode)


        sphere.firstMaterial?.isDoubleSided = true
        sphere.firstMaterial?.diffuse.contents = panoramaImage.name

        addInfoPoint()
        sphereNode.geometry = sphere
        sphereNode.name     = "sphere"
        scene.rootNode.addChildNode(sphereNode)


        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(getPointLocation(gesture:)))
        sceneView.addGestureRecognizer(panGesture)
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    
    
    

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: sceneView)
        let newY = Float(translation.x) * 0.005
        cameraNode.eulerAngles.y -= newY
        let newX = Float(translation.y) * 0.005
        cameraNode.eulerAngles.x -= newX
        gesture.setTranslation(.zero, in: sceneView)
    }
    
    
    @objc func getPointLocation(gesture:UITapGestureRecognizer){
        let sceneView   = gesture.view as! SCNView
        let taplocation = gesture.location(in: sceneView)
        let hitTest     = sceneView.hitTest(taplocation)
        
    
        if let result = hitTest.first{
            let hitNode = result.node
            if let nodeName = hitNode.name{
                buttonHandle(nodeName: nodeName,position: hitNode.position)
            }
        }else {
            
        }
    }
    
    func changeSphereImage(panoramaImage image: PanoramaImages){
        panoramaImage = image
        sceneView.scene?.rootNode.enumerateChildNodes({ nodes, _ in
            if nodes.name == "sphere"{
                nodes.removeFromParentNode()
            }
        })
        sphere.firstMaterial?.diffuse.contents = panoramaImage.name
        addInfoPoint()
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        sphereNode.geometry = sphere
        SCNTransaction.commit()
        self.sceneView.scene!.rootNode.addChildNode(sphereNode)
    }
    
    
    private func presentBottomSheet(page:Page){
        let sheetVC =  DetailVC(page: page)
        if let sheet = sheetVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(sheetVC, animated: true)
    }

   private  func buttonHandle(nodeName name:String,position :SCNVector3){
        switch panoramaImage {
        case .boarding:
            if name == "8.593408"{
                changeSphereImage(panoramaImage: .qsuite)
            }else if name ==  "9.584648"{
                changeSphereImage(panoramaImage: .economy)
            }
        case .qsuite:
            if name == "0.3079616"{
                changeSphereImage(panoramaImage: .boarding)
            }else if name ==  "6.7849364"{
                changeSphereImage(panoramaImage: .qsuite_single)
            }else if name == "7.6960306"{
                changeSphereImage(panoramaImage: .qsuite_quad)
            }else if name == "3.41066"{
                changeSphereImage(panoramaImage: .qsuite_double)
            }
        case .qsuite_single:
            if name == "9.878562"{
                changeSphereImage(panoramaImage: .qsuite)
             
            }else if name == "9.172463" {
                presentBottomSheet(page: .cabinPressure)
            }else if name == "0.15879527"{
                presentBottomSheet(page: .screen)
            }
        case .qsuite_quad:
            if name == "5.487389"{
                changeSphereImage(panoramaImage: .qsuite)
            }else if name ==  "7.0350723"{
                presentBottomSheet(page: .foodService)
            }else if name == "1.4328748"{
                presentBottomSheet(page: .screen)
            }
        case .qsuite_double:
            if name == "9.696209"{
                changeSphereImage(panoramaImage: .qsuite)
            }else if name ==  "6.4030843"{
                presentBottomSheet(page: .foodService)
            }else if name ==  "0.23471601"{
                presentBottomSheet(page: .screen)
            }else if name ==  "6.083786"{
                presentBottomSheet(page: .seats)
            }
        case .economy:
            if name == "0.8829621"{
                changeSphereImage(panoramaImage: .economy_middleseat)
            }else if name ==  "1.5090343"{
                changeSphereImage(panoramaImage: .boarding)
            }else if name == "2.93591"{
                changeSphereImage(panoramaImage: .economy_frontseat)
            }else if name == "8.25013"{
                presentBottomSheet(page: .economySeats)
            }
        case .economy_middleseat:
            if name == "0.040755395"{
                changeSphereImage(panoramaImage: .economy_middleseat_dine)
            }else if name ==  "9.69636"{
                changeSphereImage(panoramaImage: .economy)
            }
        case .economy_frontseat:
            if name == "5.41758"{
                changeSphereImage(panoramaImage: .boarding)
            }else if name ==  "2.2689335"{
                presentBottomSheet(page: .screen)
            }else if name == "9.895607" {
                presentBottomSheet(page: .cabinPressure)
            }
        case .economy_middleseat_dine:
            if name == "0.040755395"{
                changeSphereImage(panoramaImage: .economy_middleseat)
            }else if name ==  "9.69636"{
                changeSphereImage(panoramaImage: .economy)
            }
        }
    }
    
    private func addInfoPoint(){
        if sphereNode.childNodes.count > 0{
            sphereNode.childNodes.forEach { node in
                node.removeFromParentNode()
            }
        }
        let positions = panoramaImage.position
        var num = 0
        for position in positions{
//            let name = "\(panoramaImage.rawValue)\(num)"
            let name = "\(abs(position.x))"
            createButton(position: position, label: name)
            num += 1
        }
    }
    

    
   private func createButton(position : SCNVector3,label : String){
        let button             = SCNNode(geometry: SCNSphere(radius: 0.005))
        let buttonParentNode   = SCNNode(geometry: SCNSphere(radius: 0.010))
        buttonParentNode.scale = SCNVector3(x: 30, y: 30, z:30 )
        button.geometry?.firstMaterial?.diffuse.contents           = UIColor.white
        buttonParentNode.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray.withAlphaComponent(0.6)
        buttonParentNode.position  = position
        buttonParentNode.name      = label
        buttonParentNode.addChildNode(button)
        sphereNode.addChildNode(buttonParentNode)
    }
    
}

enum PanoramaImages:String {
    case boarding                = "boarding"
    case qsuite                  = "bus"
    case qsuite_single           = "sbus"
    case qsuite_quad             = "qbus"
    case qsuite_double           = "dbus"
    case economy                 = "eco"
    case economy_middleseat      = "ecomid"
    case economy_frontseat       = "ecof"
    case economy_middleseat_dine = "ecodin"
    
    
    var name : UIImage {
        switch self {
        case .boarding:
            return UIImage(named: "boarding")!
        case .qsuite:
            return UIImage(named: "qsuite")!
        case .economy_frontseat:
            return UIImage(named: "economy_frontseat")!
        case .economy_middleseat:
            return UIImage(named: "economy_middleseat")!
        case .economy_middleseat_dine:
            return UIImage(named: "economy_middleseat_dine")!
        case .qsuite_double:
            return UIImage(named: "qsuite_double")!
        case .qsuite_quad:
            return UIImage(named: "qsuite_quad")!
        case .qsuite_single:
            return UIImage(named: "qsuite_single")!
        case .economy:
            return UIImage(named: "economy")!
        }
    }
    

    var position : [SCNVector3] {
        switch self {
        case .boarding:
            return [SCNVector3(x: -8.593408, y: -1.8228006, z: 4.6730313),SCNVector3(x: 9.584648, y: -1.4710882, z: 2.2545407)]
        case .qsuite:
            return [SCNVector3(x: 0.3079616, y: -2.1676779, z: -9.702359),SCNVector3(x: -6.7849364, y: -7.190961, z: 1.1349655),SCNVector3(x: 7.6960306, y: -3.9704812, z: -4.9015126),SCNVector3(x: 3.41066, y: -0.74013454, z: 9.2665205)]
        case .qsuite_single:
            return [SCNVector3(x: -9.878562, y: -1.451988,  z: 0.050902747),SCNVector3(x: 9.172463, y: -1.7280715, z: 3.3238842),SCNVector3(x: -0.15879527, y: -1.4392182, z: 9.866898)]
        case .qsuite_quad:
            return [SCNVector3(x: -5.487389, y: -1.2309822, z: 8.185439),SCNVector3(x: 7.0350723, y: -4.3741803, z: 5.43866),SCNVector3(x: 1.4328748, y: -1.872237, z: 9.613029)]
        case .qsuite_double:
            return [SCNVector3(x: 9.696209, y: -1.8610985, z: 0.8178923),SCNVector3(x: 6.4030843, y: -4.031004, z: 6.506537),SCNVector3(x: -0.23471601, y: -1.3230735, z: 9.880005)
            ,SCNVector3(x: -6.083786, y: -7.4058657, z: 2.6428912)]
        case .economy:
            return [SCNVector3(x: -0.8829621,  y: -3.4568305, z: 9.248151), SCNVector3(x: 1.5090343, y: -1.701813, z: -9.636902),SCNVector3(x: -2.93591, y: -5.9376235, z: -7.4051857),SCNVector3(x: -8.25013, y: -3.4766703, z: 4.3259773)]
        case .economy_middleseat:
            return [SCNVector3(x: 0.040755395, y: -7.5492234, z: 6.5204706),SCNVector3(x: 9.69636, y: -1.6968039,  z: 1.0649728)]
        case .economy_frontseat:
            return [SCNVector3(x: 2.2689335, y: -6.3102584, z: 7.3643727),SCNVector3(x: 9.895607, y: -0.3124461, z: -0.6373796),SCNVector3(x: 5.41758, y: -0.9141406, z: 8.264955)]
        case .economy_middleseat_dine:
            return [SCNVector3(x: 0.040755395, y: -7.5492234, z: 6.5204706),SCNVector3(x: 9.69636, y: -1.6968039,  z: 1.0649728)]
        }
    }
    
    
    
}

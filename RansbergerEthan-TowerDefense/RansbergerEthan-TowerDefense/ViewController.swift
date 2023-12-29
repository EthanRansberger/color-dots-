//
//  ViewController.swift
//  RansbergerEthan-FinalProject
//
//  Project: Color Dots! Final Project
//  EID: EFR479
//  Class: CS329E
//

import UIKit
import CoreData

// I drew the path in paint.NET and then essentiall measured check povs like hitboxes for the enemies to clear before changing direction towards the next coordinate.
let pathfindingCoords = [
    [0,632], [77,546], [136,476], [190, 485], [205, 535], [244,577], [320, 576], [356, 506], [324, 431], [223, 365], [136, 352], [34, 382], [31, 20], [40,20], [63,34]
]

protocol loadSave {
    func loadItem(x:Float,y:Float,dx:Float,dy:Float,level:Float)
}

// remember aspect scale to fill for background!!!

let alternateCoords = [
    [66,715], [209, 654], [267,603], [216,547], [38,20], [6,497], [79,392], [167,338], [221,251], [308, 215], [318, 146]
]

class ViewController: UIViewController, loadSave {
    @IBOutlet weak var buildSwitch: UISwitch!
    
    var emptyTower = tower()
    var selectedTower = tower()
    
    var changedValue = ""
    var activeUnits: [tower] = []
 
    var queue: DispatchQueue!
    @IBOutlet weak var backgroundView: UIImageView!
    var soundValue = Float(0)
    var musicValue = Float(0)
    var speedUp = false
    var paused = false
    var normalSpeed = true
    var doubleTapCounter = "yes"
    var update = 0
    var selected = false
    var building = false
    var health = 5
    var wave = 0
    var name = ""
    var delegate: mainMenu!
    var rate = UInt32(100000)
    var scaleValue = Float(0)
    var speedValue = Float(0)
    
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var buildButton: UIButton!
    override func viewDidLoad() {
        self.scaleValue = Float(100)*self.soundValue
        self.speedValue = Float(5)*self.musicValue
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        
        
        
        
        if self.building == false {
            //hide hitboxes, make it just a translucent image
           
            print("initiating place fields")
            
        }
        queue = DispatchQueue(label: "myQueue",qos: .utility)
        queue.async {
            self.startWaves()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
    }
    
    
    @IBAction func switchtoRandomizer(_ sender: Any) {
        for item in activeUnits{
            if item.randomized == false{
                item.randomized=true
            }
            else{
                item.randomized=false
            }
        }
    }
    @IBAction func colorChange(_ sender: Any) {
        switch segment.selectedSegmentIndex {
        case 0:
            for item in activeUnits{
                item.RG=true
                item.GB=false
                item.BR=false
            }
            
        case 1:
            for item in activeUnits{
                item.RG=false
                item.GB=true
                item.BR=false
            }
           
        case 2:
            for item in activeUnits{
                item.RG=false
                item.GB=false
                item.BR=true
            }
            
       
        default:
            print("shouldn't occur")
        }
    }
    @IBAction func switchtoBuild(_ sender: Any) {
        if self.building == false {
            self.building = true
            if self.selectedTower != emptyTower{
                self.selectedTower.selected=false
                self.selectedTower = emptyTower
            }
            self.selected = false
        }
        else{
            self.building = false
        }
    }
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var runningLabel: UILabel!
    func startWaves(){
        //play music at volume,
        print("test")
        while true{
            
            usleep(self.rate)
            if paused==false{
            
                if runningLabel.isHidden == false{
                    DispatchQueue.main.async {
                        self.runningLabel.isHidden = true
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.runningLabel.isHidden = false
                    }
                }
                
                DispatchQueue.main.async {
                    self.attack()
                }
                
                
                
            }
            // will refer to path finding for each thing initiated
            
            
        }
    }

    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    
    @IBOutlet weak var pauseButton: UIButton!
    
    

    
    @IBAction func upgradePressed(_ sender: Any) {
        if selected == true {
            self.selectedTower.increaseLevel()
        }
    }
    
    
    
    @IBAction func pausePressed(_ sender: Any) {
        if self.paused == true {
            self.paused = false
            self.doubleTapCounter = "yes"
            self.normalSpeed = true
            self.speedUp = false
            print("unpaused")
            self.pauseButton.setTitle("pause", for: .normal)
           // self.queue.suspend()
            self.pauseButton.isEnabled = true
            
        }
        else {
            self.playButton.isEnabled = false
            self.paused = true
            self.doubleTapCounter = "no"
            self.normalSpeed = false
            self.speedUp = false
            print("paused")
            self.pauseButton.setTitle("unpause", for: .normal)
           // self.queue.resume()
        }
    }
    
        @IBAction func playSpeed(_ sender: Any) {
            if self.doubleTapCounter == "no" {
                self.normalSpeed = true
                self.speedUp = false
                self.paused = false
                doubleTapCounter = "yes"
                print("play")
                self.rate = UInt32(100000)
                //self.playButton.titleLabel?.text = "Speed up"
                self.playButton.setTitle("speed up", for: .normal)
            }
            else {
                self.normalSpeed = false
                self.speedUp = true
                self.paused = false
                print("speed up")
                doubleTapCounter = "no"
                self.rate=UInt32(50000)
                self.playButton.setTitle("normal", for: .normal)
               // self.playButton.titleLabel?.text = "Normalv"
            }
        }
    
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
       
        //what tapping on the screen will vary on the tools selected
        // tap to place
        //tap to upgrade or change traget
        let point = sender.location(in: self.view)
        let x = point.x
        let y = point.y
        if building == true {
            print("building at coords")
            
            let directionx = Float.random(in:-1...1)
            let directiony = Float.random(in:-1...1)
            let level = Float(1)
            
            self.loadItem(x: Float(x), y: Float(y), dx: directionx, dy: directiony, level: level)
        }
        else {
            print("checking if selectable")
            for item in activeUnits {
               
                
                
                if ((point.x - CGFloat(self.scaleValue))...(point.x + CGFloat(self.scaleValue))).contains(item.frame.origin.x){
                    selectedTower = item
                    item.backgroundColor = .green
                    
                    //selectedTower.selected=true
                    //self.upgradeButton.isEnabled = true
                    selectedTower.increaseLevel()
                    selectedTower = emptyTower
                   
                }
            }
        }
    }
    
    
    
    @IBAction func clearAllNodes(_ sender: Any) {
        for item in activeUnits{
            item.removeFromSuperview()
        }
    }
    
    
   
   
    @IBAction func cancelActivated(_ sender: Any) {
        //cancels placing or closes upgrade window
    }
    
   
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    func attack() {
        //for loop for all active units
        // the target will be the latest item in the queue for enemies
        if (self.activeUnits.count-1) >= 0 {
            for i in 0...(self.activeUnits.count-1){
                var currentUnit = self.activeUnits[i]
                
                currentUnit.move()
              //  print(currentUnit.frame.origin.x)
              //  print(currentUnit.frame.origin.y)
            }
        }
    }
    
    func loadItem(x:Float, y:Float, dx:Float, dy:Float, level:Float){
        let newTower = tower()
        newTower.frame = CGRect(x:CGFloat(x), y:CGFloat(y), width: CGFloat(self.scaleValue), height: CGFloat(self.scaleValue))
        newTower.speed = Int(self.speedValue)
        
        newTower.width = view.bounds.width
        newTower.length = view.bounds.height
        newTower.directionx = CGFloat(dx)
        newTower.directiony = CGFloat(dy)
        newTower.backgroundColor = .red
        for _ in Int(0)..<Int(level){
            newTower.increaseLevel()
        }
        
        newTower.layer.cornerRadius = (CGFloat(0.5))*(newTower.frame.width)
      //  newTower.image = UIImage(named:"tower.png")
        newTower.contentMode = .scaleToFill
        
        activeUnits.append(newTower)
        view.addSubview(newTower)
       // newTower.image = UIImage(named:"tower.png")
       
    }
   
    @IBAction func saveItems(_ sender: Any) {
        yestoSave()
    }
    
    func yestoSave(){
        //delegate.clearSettings(namestring:"Renders")
        let other = delegate! as mainMenu
        other.clearSettings(namestring: "Renders")
        for item in activeUnits{
            let nextVC = delegate! as saveRender
            nextVC.saveData(x:Float(item.frame.origin.x),y:Float(item.frame.origin.y),dx:Float(item.directionx),dy:Float(item.directiony),level:Float(item.level))
            
            delegate.loadit=true
        }
    }
    
    
  
}







//
//  settingsMenu.swift
//  RansbergerEthan-FinalProject
//
//  Project: Color Dots! Final Project
//  EID: EFR479
//  Class: CS329E
//
//

import UIKit
import CoreData
//let appDelegate = UIApplication.shared.delegate as! AppDelegate
//let context = appDelegate.persistentContainer.viewContext
class settingsMenu: UIViewController {
    var changedValue = ""
    var soundValue = Float(0)
    var musicValue = Float(0)
    @IBOutlet weak var quittoMenu: UIButton!
    var delegate: UIViewController!
    var menuDelegate: mainMenu!
  
    override func viewDidLoad(){
        super.viewDidLoad()
        self.changedValue = ""
        self.sfxSlider.value = Float(soundValue)
        self.musicSlider.value = Float(musicValue)
        //self.soundValue = Int(sfxSlider.value)
        //self.musicValue = Int(musicSlider.value)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGame", let nextVC = segue.destination as? ViewController {
            nextVC.musicValue = self.musicValue
            nextVC.soundValue = self.soundValue
        }
        
    }
    @IBAction func exitSettings(_ sender: Any) {
        //present notification to save settings?
        //if fromGame == false {
        exitSettingsToMain()
        //}
    }
    func exitSettingsToMain() {
        let controller = UIAlertController(
            title: "Save Settings",
            message: "Would you like to save your changes?",
            preferredStyle: .alert)
        
        
        controller.addAction(UIAlertAction(title: "yes", style: .default, handler: {
            (action) in self.gotoMenu()
        }))
        controller.addAction(UIAlertAction(title: "no", style: .default, handler: {
            (action) in self.changedValue = "no"
        }))
        present(controller, animated: true)
    }
            
    func gotoMenu() {
        if (menuDelegate != nil) {
            let nextVC = menuDelegate! as changeSettingsMain
            nextVC.newSettings(music: Float(self.musicSlider.value), sfx: Float(self.sfxSlider.value))
            print("sending settings to menu")
            //self.dismiss(animated: true)
            // will performa  protocol for either the main menu or back to the game depending on which btton
            //perform segue of id updategame or updatemenu
        }
        }
    
    @IBAction func quitToMenu(_ sender: Any) {
        let controller = UIAlertController(
            title: "You are about to return to menu",
            message: "Are you sure you want to go to menu?",
            preferredStyle: .alert)
        
       
        controller.addAction(UIAlertAction(title: "yes", style: .default, handler: {
            (action) in self.changedValue = "Yes"
        }))
        controller.addAction(UIAlertAction(title: "no", style: .default, handler: {
            (action) in self.changedValue = "no"
        }))
        present(controller, animated: true)
        
        if (self.changedValue=="yes"){
            print("exit settings:")
           
            exitSettingsToMain()
        }
        }
        
    
    @IBOutlet weak var musicSlider: UISlider!
    @IBOutlet weak var sfxSlider: UISlider!
}

//
//  tower.swift
//  RansbergerEthan-FinalProject
//
//  Project: Color Dots! Final Project
//  EID: EFR479
//  Class: CS329E
//
//

import UIKit
import CoreAudio
import AVFAudio

class tower: UIImageView {
    var health = 5
    var speed = 5
  
    var level = 1
   
    
    var x = 0
    var y = 0
    var targetX = 0
    var targetY = 0
    var width = CGFloat(0)
    var length = CGFloat(0)
    var directionx = CGFloat(1)
    var directiony = CGFloat(1.0)
    var value = CGFloat(1.0)
    var selected = false
    var randomized = false
    var RG = true
    var GB = false
    var BR = false
    
    func changeColor(){
   
            let one = Float(self.frame.origin.x)/Float(self.width)+Float(0.001)
            let two = Float(self.frame.origin.y)/Float(self.length)+Float(0.001)
            //let blue = Float(abs(red*green))
            var three = Float.random(in:0.001...0.999)
        if self.randomized==false{
                three = Float(one*two)+Float(0.01)
            }
            let alpha = Float(1)
            var red = one
            var green = two
            var blue = three
            if RG==true{
                 red = one
                 green = two
                 blue = three
            }
            else if GB == true {
                 red = three
                 green = one
                 blue = two
                
            }
            else if BR == true {
                 red =  two
                 green = three
                 blue = one
            }
            
            self.backgroundColor = UIColor(_colorLiteralRed: red, green: green, blue: blue, alpha: alpha)
        
       
        }
    
    func move() {
        self.changeColor()
        self.frame.origin.x += directionx * CGFloat(level) * CGFloat(self.speed)
        self.frame.origin.y += directiony * CGFloat(level) * CGFloat(self.speed)
        
        if self.frame.origin.x <= CGFloat(0) {
            self.directionx=CGFloat.random(in:CGFloat(0)...value)
            self.directiony=CGFloat.random(in:-value...value)
            
        }
        else if self.frame.origin.x >= width {
            self.directionx=CGFloat.random(in:-value...CGFloat(0))
            self.directiony=CGFloat.random(in:-value...value)
            
        }
        if self.frame.origin.y <= CGFloat(0) {
            self.directionx=CGFloat.random(in:-value...value)
            self.directiony=CGFloat.random(in:CGFloat(0)...value)
          
        }
        else if self.frame.origin.y >= length {
            self.directionx=CGFloat.random(in:-value...value)
            self.directiony=CGFloat.random(in:-value...CGFloat(0))
           
        }
    }
    func increaseLevel(){
        self.level+=1
        let widthadjust = self.frame.width*(CGFloat(1)+CGFloat(level)/CGFloat(10))
        let heightadjust = self.frame.height*(CGFloat(1)+CGFloat(level)/CGFloat(10))
        self.frame.size = CGSize(width: widthadjust, height: heightadjust)
    }
   
    
}

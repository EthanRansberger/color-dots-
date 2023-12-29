//
//  tableReloader.swift
//  RansbergerEthan-TowerDefense
//
//  Project: Color Dots! Final Project
//  EID: EFR479
//  Class: CS329E
//
//

import UIKit


class tableReloader: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
}

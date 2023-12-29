//
//  mainMenu.swift
//  RansbergerEthan-FinalProject
//
//  Project: Color Dots! Final Project
//  EID: EFR479
//  Class: CS329E
//
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

protocol changeSettingsMain {
    func newSettings(music:Float, sfx:Float)
}

protocol saveRender {
    func saveData(x:Float,y:Float,dx:Float,dy:Float,level:Float)
    
}

var highscores = [[""]]
var loadingArray=[[Float(0),Float(0),Float(0),Float(0),Float(0)]]

class mainMenu: UIViewController, UITableViewDelegate, UITableViewDataSource, changeSettingsMain, saveRender  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highscores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("loading cells")
        let cell = highscoreBoard.dequeueReusableCell(withIdentifier: "scorecell", for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = highscores[row].joined(separator: ", ")
        
        return cell
    }
    
    var soundValue = Float(0.50)
    var musicValue = Float(0.50)
    
    var settings = [[Float(0)]]
    @IBOutlet weak var highscoreBoard: UITableView!
    override func viewDidLoad() {
        loadAll()
        loadSettings()
        super.viewDidLoad()
        
        highscoreBoard.delegate = self
        highscoreBoard.dataSource = self
        
       
    }
    
    @IBAction func clearPressed(_ sender: Any) {
        clearSettings(namestring:"Renders")
        clearSettings(namestring:"Settings")
        highscores = [[""]]
        loadingArray = [[Float(0),Float(0),Float(0),Float(0),Float(0)]]
        
    }
         
            
           
    
    
    func clearSettings(namestring:String){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: namestring)
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            if fetchedResults.count > 0 {
                for result in fetchedResults {
                    context.delete(result)
                }
            }
            saveContext()
        } catch {
            print("Error during clear")
            abort()
        }
    }
    
    var loadit = true
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue", let nextVC = segue.destination as? settingsMenu {
            nextVC.menuDelegate = self
           
            nextVC.musicValue = self.musicValue
            nextVC.soundValue = self.soundValue
        }
        
        if segue.identifier == "startGame", let nextVC = segue.destination as? ViewController {
            nextVC.musicValue = self.musicValue
            nextVC.soundValue = self.soundValue
            nextVC.delegate = self
            if loadit==true{
                loadSettings()
            }
            for item in loadingArray{
                let delegating = segue.destination as? loadSave
                delegating?.loadItem(x: Float(item[0]), y: Float(item[1]), dx: Float(item[2]), dy: Float(item[3]), level: Float(item[4]))
            }
        }
    }
    
    func newSettings(music:Float, sfx:Float){
        self.musicValue = music
        self.soundValue = sfx
        print(self.musicValue,self.soundValue)
        storeSettings(music:music, sfx:sfx)
    }
    
    func storeSettings(music:Float, sfx:Float){
        clearSettings(namestring: "Settings")
        let soundSettings = NSEntityDescription.insertNewObject(forEntityName: "Settings", into: context)
        soundSettings.setValue(music, forKey: "music")
        soundSettings.setValue(sfx, forKey: "sfx")
        
        saveContext()
        
    }
    
    @IBAction func loadPressed(_ sender: Any) {
        self.loadAll()
  
    }
    func loadSettings(){
        let data = self.retrieveSave(nameString: "Settings")
        
        for item in data{
            if let sou = item.value(forKey:  "sfx") as? Float{
                if let mus = item.value(forKey: "music") as? Float {
                    self.soundValue=sou
                    self.musicValue=mus
                    
                }
            }
        }
            
        
    }
     
   func loadAll(){
        let data = self.retrieveSave(nameString: "Renders")
        highscores = [[String]]()
        
        for item in data {
            if let x = item.value(forKey: "x") as? Float {
                if let y = item.value(forKey: "y") as? Float {
                    if let dy = item.value(forKey: "dy") as? Float {
                        if let dx = item.value(forKey: "dx") as? Float {
                            if let level = item.value(forKey: "level") as? Float {
                                var newarray=[""]
                                newarray.append(NSString(format:"%.2f", x as CVarArg) as String)
                                newarray.append(NSString(format:"%.2f", y as CVarArg) as String)
                                newarray.append(NSString(format:"%.2f", dx as CVarArg) as String)
                                newarray.append(NSString(format:"%.2f", dy as CVarArg) as String)
                                newarray.append(NSString(format:"%.2f", level as CVarArg) as String)
                                highscores.append(newarray)
                                    var otherarray = [x,y,dx,dy,level] as [Float]
                                loadingArray.append(otherarray)
                            }
                        }
                    }
                }
                
                }
            }
    }
   
    func saveData(x:Float, y:Float, dx:Float, dy:Float, level:Float){
      //  clearSettings(namestring:"Renders")
       
        let saveSettings = NSEntityDescription.insertNewObject(forEntityName: "Renders", into: context)
        saveSettings.setValue(x, forKey:"x")
        saveSettings.setValue(y, forKey: "y")
        saveSettings.setValue(dx, forKey: "dx")
        saveSettings.setValue(dy, forKey: "dy")
        saveSettings.setValue(level, forKey: "level")
        saveContext()
    }
    
    
    func retrieveSave(nameString:String) -> [NSManagedObject] {
        // retrieve all of the Person objects in Core Data
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: nameString)
        var fetchedResults:[NSManagedObject]? = nil
    
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            print("Error occured while retrieving data")
            abort()
        }
        print(fetchedResults)
        return (fetchedResults)!
    }

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

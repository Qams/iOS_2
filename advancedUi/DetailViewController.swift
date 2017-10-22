//
//  DetailViewController.swift
//  advancedUi
//
//  Created by kamil on 22/10/2017.
//  Copyright © 2017 kamil. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var albumField: UITextField!
    @IBOutlet weak var genreField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var tracksField: UITextField!
    
    @IBAction func buttonAction(_ sender: UIButton) {
        print("Button was clicked")
        var tab = [String: Any]()
        tab["artist"] = artistField.text
        tab["album"] = albumField.text
        tab["genre"] = genreField.text
        tab["year"] = yearField.text
        tab["tracks"] = tracksField.text
        objects.remove(at: positionIndex)
        objects.insert(tab, at: positionIndex)
    }
    
    var positionIndex : Int = 0

    
    func buttonClicked(sender : UIButton!) {
        print("Added!")
        let row = sender.tag;
        print(row)
        
    }
    
    func configureView() {
        if let detail = self.detailItem {
            if let labelArtist = self.artistField {
                labelArtist.text = detail["artist"] as! String?
            }
            if let labelAlbum = self.albumField {
                labelAlbum.text = detail["album"] as! String?
            }
            if let labelGenre = self.genreField {
                labelGenre.text = detail["genre"] as! String?
            }
            if let labelYear = self.yearField {
                labelYear.text = String(describing: (detail["year"])!)
            }
            if let labelTracks = self.tracksField {
                labelTracks.text = String(describing: (detail["tracks"])!)
            }
            let pos = objects.index(where: {$0["artist"] as! String == detail["artist"] as! String && $0["album"] as! String == detail["album"] as! String})! + 1
            positionIndex = pos - 1;
            self.navigationItem.title = "Edit \(pos) in \(objects.count)"
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.deleteObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        self.configureView()
    }
    
    func deleteObject(_ sender: Any) {
        objects.remove(at: positionIndex)
        performSegue(withIdentifier: "tomainsegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    var detailItem: [String:Any]? {
        didSet {
            self.configureView()
        }
    }


}


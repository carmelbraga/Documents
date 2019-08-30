//
//  DocumentsViewController.swift
//  Documents
//
//  Created by Carmel Braga on 8/30/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//

import UIKit

struct Document{
    let name: String
    let size: UInt64
    let url: URL
    let date: Date
    
    var information: String? {
     get {
     return try? String(contentsOf: url, encoding: .utf8)
     }
     }
}

class DocumentInfo {
    
    class func get() -> [Document] {
        var documents = [Document]()
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if let urls = try? FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: nil) {
            for url in urls {
                let name = url.lastPathComponent
                if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
                    let size = attributes[FileAttributeKey.size] as? UInt64,
                    let date = attributes[FileAttributeKey.modificationDate] as? Date {
                    documents.append(Document(name: name, size: size, url: url, date: date))
                }
            }
        }
        
        return documents
    }
    
    class func delete(url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
    
    class func save(name: String, information: String) {
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = docURL.appendingPathComponent(name)
        
        try? information.write(to: url, atomically: true, encoding: .utf8)
    }
}

class DocumentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var documents = [Document]()
    
    @IBOutlet weak var documentsTableView: UITableView!
    
    let modDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       modDateFormatter.dateStyle = .medium
       modDateFormatter.timeStyle = .medium
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       documents = DocumentInfo.get()
       documentsTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath) as? DocumentsTableViewCell
        
        let document = documents[indexPath.row]
        
        cell?.nameLabel.text = document.name
        cell?.sizeLabel.text = String(document.size) + " bytes"
        cell?.dateLabel.text = modDateFormatter.string(from: document.date)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let document = self.documents[indexPath.row]
            DocumentInfo.delete(url: document.url)
            self.documents = DocumentInfo.get()
            self.documentsTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [delete]
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "existingDocument" {
            if let destination = segue.destination as? SingleDocumentViewController,
                let row = documentsTableView.indexPathForSelectedRow?.row{
                destination.document = documents[row]
            }
            
        }
    }

}

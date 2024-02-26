//
//  ViewController.swift
//  homework8
//
//  Created by НИКИТА ПЕСНЯК on 25.01.24.
//

import UIKit
typealias Person = (name: String, lastMessage: String)
final class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var EditButtonOne: UIButton!
    @IBOutlet private weak var views: UIView!
    @IBOutlet private weak var tableViewName: UITextField!
    @IBOutlet private weak var tableViewMassege: UITextField!
    @IBOutlet private weak var plusButton: UIButton!
   
       private var isEdingButton = false
       private var isplusEditButton = false
    private var persons: [Person] = [("Ilya", "Drop"), ("Ivan", "Feel"), ("Maksim", "Good"), ("Nick", "Did")]
       private var sortedPersons: [String: [Person]] = [:]
       private var sectionTitles: [String] = []
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           // Do any additional setup after loading the view.
           tableView.dataSource = self
           tableView.delegate = self
           tableView.isEditing = false
           views.isHidden = true
           
           sortedPersons = sortPersons(persons)
           sectionTitles = sortedPersons.keys.sorted()
       }
       
       func numberOfSections(in tableView: UITableView) -> Int {
           return sectionTitles.count
       }
       
       func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return sectionTitles[section]
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           let key = sectionTitles[section]
           return sortedPersons[key]?.count ?? 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "SomeCellIdentifier", for: indexPath) as? PersonViewController
           
           let key = sectionTitles[indexPath.section]
           let personsInSection = sortedPersons[key]
           
           if let person = personsInSection?[indexPath.row] {
               cell?.nameLable.text = person.name
               cell?.lastMessageLable.text = person.lastMessage
               
           }
           
           return cell!
       }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let key = sectionTitles[indexPath.section]
            if var personsInSection = sortedPersons[key] {
                personsInSection.remove(at: indexPath.row)
                sortedPersons[key] = personsInSection
                persons = sortedPersons.values.flatMap { $0 }
            }
            
            sectionTitles = sortedPersons.keys.sorted()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction private func plusEditButton(){
      
        if isplusEditButton{
             views.isHidden = true
             textFieldShouldReturn(tableViewName)
             textFieldShouldReturn(tableViewMassege)
             
             let newPerson = (tableViewName.text ?? "", tableViewMassege.text ?? "")
             persons.append(newPerson)
             
             sortedPersons = sortPersons(persons)
             sectionTitles = sortedPersons.keys.sorted()
             
             tableView.reloadData()
         }
         else {
             views.isHidden = false
         }
         isplusEditButton.toggle()
     }
    @IBAction private func editButton() {
        
        if isEdingButton{
            tableView.isEditing = false
            EditButtonOne.setTitle("Edit", for: .normal)
        }
        else{
            tableView.isEditing = true
            EditButtonOne.setTitle("Done", for: .normal)}
        isEdingButton.toggle()
    }
    private func sortPersons(_ persons: [Person]) -> [String: [Person]] {
        var sortedDict: [String: [Person]] = [:]
        
        let sortedArray = persons.sorted { $0.name < $1.name }
        
        for person in sortedArray {
            let firstLetter = String(person.name.prefix(1))
            
            if var section = sortedDict[firstLetter] {
                section.append(person)
                sortedDict[firstLetter] = section
            } else {
                sortedDict[firstLetter] = [person]
            }
        }
        
        return sortedDict
    }
    }
        
        


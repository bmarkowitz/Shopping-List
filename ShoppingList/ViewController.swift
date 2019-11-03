//
//  ViewController.swift
//  ShoppingList
//
//  Created by Brett Markowitz on 11/3/19.
//  Copyright © 2019 Brett Markowitz. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var listItems = ["Apples"]
    
    override func loadView() {
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Shopping List"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))
        
        navigationItem.rightBarButtonItems = [addButton, shareButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text = listItems[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        listItems.remove(at: indexPath.row)
        
        tableView.reloadData()
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add an item...", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            self?.listItems.append(text)
            
            if self?.navigationItem.leftBarButtonItem == nil {
                self?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(self?.clearList))
            }
            
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
    }
    
    @objc func shareList() {
        let listItemsString = listItems.joined(separator: ", ")
        let avc = UIActivityViewController(activityItems: [listItemsString], applicationActivities: [])
        guard let shareBarButtonItem = navigationItem.rightBarButtonItems?[1] else { return }
        avc.popoverPresentationController?.barButtonItem = shareBarButtonItem
        present(avc, animated: true)
    }
    
    @objc func clearList() {
        let ac = UIAlertController(title: "Clear list", message: "Are you sure you want to clear all items from the list?", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Yes", style: .destructive) {
            [weak self] _ in
            self?.listItems.removeAll()
            self?.navigationItem.leftBarButtonItem = nil
            self?.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
}


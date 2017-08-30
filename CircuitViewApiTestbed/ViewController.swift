//
//  ViewController.swift
//  CircuitViewApiTestbed
//
//  Created by Lutrons on 30/08/2017.
//  Copyright © 2017 Lutrons Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var txtSchoolName: UITextField!
    @IBOutlet weak var tblRooms: UITableView!
    
    let disposeBag = DisposeBag()
    let api : CircuitViewAPI = CircuitViewServiceHost()
    var school : Variable<CVSchool?> = Variable(nil)

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Update the school name field if a value has been loaded
        school.asObservable()
            .map({$0?.name})
            .bind(to: txtSchoolName.rx.text)
            .addDisposableTo(disposeBag)
        
        // Map the school rooms to the table if loaded
        school.asObservable()
            .map({$0?.rooms ?? []})
            .bind(to: tblRooms.rx.items(cellIdentifier: "RoomCell", cellType: UITableViewCell.self)) {
                row, room, cell in
                cell.textLabel?.text = room.campusName
                cell.detailTextLabel?.text = "\(room.roomName) - \(room.location)"
            }
            .addDisposableTo(disposeBag)
    }


    @IBAction func actionTestApi(_ sender: Any) {
        api.rooms()
        .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {[weak self] result in
                    self?.school.value = result
                },
                onError: { error in
                    // Deal with the error as required
                    print("ERROR: \(error)")
            })
        .addDisposableTo(disposeBag)
    }
    
}


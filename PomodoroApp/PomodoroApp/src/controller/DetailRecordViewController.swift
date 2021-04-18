//
//  DetailRecordViewController.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/04/17.
//

import UIKit

class DetailRecordViewController: UIViewController {

    @IBOutlet weak var detailRecordTableView: UITableView!
    
    private var totalPomodoroTime = 0
    private var todayPomodoroTime = 0
    private var thisWeekPomodoroTime = 0
    private var currentMonthPomodoroTime = 0
    private var oneDatePomodoroTimeAverage = 0
    private var weekPomodoroTimeAverage = 0
    private var pastThreeDatePomodoroTimeAverage = 0
    
    private var detailRecordItem = [
        ["item": "累計のポモドーロ時間", "time": "0"],
        ["item": "本日のポモドーロ時間", "time": "0"],
        ["item": "今週のポモドーロ時間", "time": "0"],
        ["item": "今月のポモドーロ時間", "time": "0"],
        ["item": "1日のポモドーロ時間の平均", "time": "0"],
        ["item": "1週間のポモドーロ時間の平均", "time": "0"],
        ["item": "過去3日のポモドーロ時間の平均", "time": "0"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegate()
        detailRecordViewRegister()
    }
}

extension DetailRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableViewDelegate() {
        detailRecordTableView.delegate = self
        detailRecordTableView.dataSource = self
    }
    
    func detailRecordViewRegister() {
        detailRecordTableView.register(UINib(nibName: "DetailRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailRecordItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailRecordTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! DetailRecordTableViewCell
        cell.detailRecordItem.text = detailRecordItem[indexPath.row]["item"]
        cell.detailRecordTime.text = detailRecordItem[indexPath.row]["time"]
        return cell
    }
}

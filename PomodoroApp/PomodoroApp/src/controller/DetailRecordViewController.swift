//
//  DetailRecordViewController.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/04/17.
//

import UIKit

class DetailRecordViewController: UIViewController {

    @IBOutlet weak var detailRecordTableView: UITableView!

    private var detailRecordItem = [[RecordItem]]()
    
    struct RecordItem {
        var item: String
        var time: String
    }
    
    struct RecordItems {
        var total: RecordItem
        var today: RecordItem
        var recentlySevenDays: RecordItem
        var currentMonth: RecordItem
        var dateAverage: RecordItem
        var recentlyThreeDaysAverage: RecordItem
        var recentlySevenDaysAverage: RecordItem
        
        init() {
            self.total = RecordItem(item: "累計ポモドーロ時間", time: String(DetailRecordDataModel.detailRecordDataModel.totalTimeRecord()))
            self.today = RecordItem(item: "本日のポモドーロ時間", time: String(DetailRecordDataModel.detailRecordDataModel.todayTimeRecord()))
            self.recentlySevenDays = RecordItem(item: "最近7日間のポモドーロ時間", time: String(DetailRecordDataModel.detailRecordDataModel.recentlySevenDaysTimeRecord()))
            self.currentMonth = RecordItem(item: "今月のポモドーロ時間", time: String(DetailRecordDataModel.detailRecordDataModel.currentTimeRecord()))
            self.dateAverage = RecordItem(item: "1日のポモドーロ時間の平均", time: String(DetailRecordDataModel.detailRecordDataModel.dailyTimeAverageRecord()))
            self.recentlyThreeDaysAverage = RecordItem(item: "最近3日間のポモドーロ時間の平均", time: String(DetailRecordDataModel.detailRecordDataModel.recentlyThreeDaysTimeAverageRecord()))
            self.recentlySevenDaysAverage = RecordItem(item: "最近7日間のポモドーロ時間の平均", time: String(DetailRecordDataModel.detailRecordDataModel.recentlySevenDaysTimeAverageRecord()))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegate()
        detailRecordViewRegister()
        displayData()
    }
    
    func displayData() {
        let recordItems = RecordItems()
        detailRecordItem.append(contentsOf: [
            [recordItems.total],
            [recordItems.today],
            [recordItems.recentlySevenDays],
            [recordItems.currentMonth],
            [recordItems.dateAverage],
            [recordItems.recentlyThreeDaysAverage],
            [recordItems.recentlySevenDaysAverage]
        ])
    }
}

// テーブルビュー用
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
        cell.detailRecordItem.text = detailRecordItem[indexPath.row][0].item
        cell.detailRecordTime.text = detailRecordItem[indexPath.row][0].time
        return cell
    }
}

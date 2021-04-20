//
//  RecordViewController.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/04/17.
//

import UIKit
import Charts

final class RecordViewController: UIViewController {
    public static let recordViewController = RecordViewController()
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var chevronLeftButton: UIButton!
    @IBOutlet weak var chevronRightButton: UIButton!
    var backTimerScreenButton: UIBarButtonItem!
    
    // グラフに表示させる配列
    private var rawData: [Double] = []
    // chevronアイコンで表示を変えるための変数
    private var changeReference = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayGraph()
        graphAppearance()
        dateSegmentSwitching((Any).self)
        GraphDataModel.graphDataModel.addSecondsData()
        putGraphLabel(numberChangeReference: 0)
        switchingGraph()
        navigationBarStopButton()
    }
    
    // 詳細画面へ遷移
    @IBAction func transitionDetail(_ sender: Any) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    // タイマー画面へ遷移
    @objc func backTimerScreen (_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    // セグメント切り替え時
    @IBAction func dateSegmentSwitching(_ sender: Any) {
        putGraphLabel(numberChangeReference: 0)
        switchingGraphScale()
        switchingGraph()
    }
    
    // chevron.left
    @IBAction func previousItemsButton(_ sender: Any) {
        putGraphLabel(numberChangeReference: 1)
        switchingGraph()
    }
    
    // chevron.right
    @IBAction func nextItemsButton(_ sender: Any) {
        putGraphLabel(numberChangeReference: -1)
        switchingGraph()
    }
    
    // ナビゲーションボタンの生成
    func navigationBarStopButton() {
        backTimerScreenButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backTimerScreen(_:)))
        self.navigationItem.leftBarButtonItems = [backTimerScreenButton]
    }
}

// グラフ表示用
extension RecordViewController {
    func displayGraph() {
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = BarChartDataSet(entries: entries)
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        dataSet.drawValuesEnabled = false
    }
    
    // グラフの外観
    func graphAppearance() {
        barChartView.legend.enabled = false
        // X座標軸の設定
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelTextColor = .systemGray
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.granularity = 1.0
    
        // Y座標軸の設定
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.axisMaximum = 8.0
        barChartView.leftAxis.drawZeroLineEnabled = true
        barChartView.leftAxis.zeroLineColor = .systemGray
        barChartView.leftAxis.labelTextColor = .systemGray
        barChartView.leftAxis.gridColor = .systemGray
        barChartView.leftAxis.drawAxisLineEnabled = false
    }
    
    //x軸のラベルを設定する
    // セグメントが「週」選択時
    class weekBarChartFormatter: NSObject, IAxisValueFormatter {
        let week: [String]! = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return week[Int(value)]
        }
    }
    // セグメントが「月」選択時
    class monthBarChartFormatter: NSObject, IAxisValueFormatter {
        let month: [String]! = [
            "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
            "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
            "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"
        ]
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return month[Int(value)]
        }
    }
}

// ラベル用
extension RecordViewController {
    // トータルポモドーロタイムを表示するための処理
    func putGraphLabel(numberChangeReference: Int) {
        changeReference += numberChangeReference
        let oneHourSeconds: Int = 3600
        switch segment.selectedSegmentIndex {
        case 0:
            let particularItem = Int(DateModel.dateModel.lastDate()) - Int(DateModel.dateModel.todayDate())!
            let particularTime = GraphDataModel.graphDataModel.currentMonthData.count - particularItem - changeReference
            let targetTime = GraphDataModel.graphDataModel.currentMonthData[particularTime]["time"]
            let targetDate = GraphDataModel.graphDataModel.currentMonthData[particularTime]["date"]
            // 小数第二位で繰り上げる
            let convertSecondsIntoHour = round(Double(targetTime!)! / Double(oneHourSeconds) * 10) / 10
            totalTimeLabel.text = String("\(convertSecondsIntoHour)h")
            dateLabel.text = targetDate
        default: break
        }
        notDestinationData()
    }
    // chevronで表示するデータがない時
    func notDestinationData() {
        switch segment.selectedSegmentIndex {
        case 0:
            if dateLabel.text == "\(DateModel.dateModel.currentMonth())/1" {
                chevronLeftButton.isEnabled = false
            } else if dateLabel.text == "\(DateModel.dateModel.currentMonth())/\(DateModel.dateModel.todayDate())" {
                chevronRightButton.isEnabled = false
            } else {
                chevronLeftButton.isEnabled = true
                chevronRightButton.isEnabled = true
            }
        default: break
        }
    }
}

// グラフ用
extension RecordViewController {
    // セグメントに合わせて、グラフの表示を切り替える
    func switchingGraph() {
        rawData = []
        let oneHourSeconds: Int = 3600
        switch segment.selectedSegmentIndex {
        case 0:
            let particularItem = Int(DateModel.dateModel.lastDate()) - Int(DateModel.dateModel.todayDate())!
            let particularTime = GraphDataModel.graphDataModel.currentMonthData.count - particularItem - changeReference
            let targetTime = GraphDataModel.graphDataModel.currentMonthData[particularTime]["time"]
            let convertSecondsIntoHour = round(Double(targetTime!)! / Double(oneHourSeconds) * 10) / 10
            rawData.append(convertSecondsIntoHour)
        case 1:
            rawData = [4.3, 8.2, 4.1, 5.9, 3.0, 9.6, 1.7]
        case 2:
            rawData = [
                10.0, 8.0, 4.0, 5.0, 12.0, 9.0, 9.0, 8.0, 5.0, 15.0,
                10.0, 8.0, 4.0, 5.0, 12.0, 9.0, 9.0, 8.0, 5.0, 15.0,
                10.0, 8.0, 4.0, 5.0, 12.0, 9.0, 9.0, 8.0, 5.0, 15.0
            ]
        default: break
        }
        displayGraph()
    }
    
    // セグメントに合わせて、グラフの目盛を切り替える
    func switchingGraphScale() {
        switch segment.selectedSegmentIndex {
        case 0:
            barChartView.xAxis.enabled = false
        case 1:
            barChartView.xAxis.enabled = true
            barChartView.xAxis.labelCount = 7
            barChartView.xAxis.valueFormatter = weekBarChartFormatter()
        case 2:
            barChartView.xAxis.enabled = true
            barChartView.xAxis.labelCount = 10
            barChartView.xAxis.valueFormatter = monthBarChartFormatter()
        default: break
        }
    }
}

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
    private (set) internal var changeReference = 1
    private var secondsTotalTime = 0
    
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
        changeReference = 1
        putGraphLabel(numberChangeReference: 0)
        switchingGraphScale()
        switchingGraph()
    }
    
    // chevron.left
    @IBAction func previousItemsButton(_ sender: Any) {
        putGraphLabel(numberChangeReference: 1)
        switchingGraph()
        switchingGraphScale()
    }
    
    // chevron.right
    @IBAction func nextItemsButton(_ sender: Any) {
        putGraphLabel(numberChangeReference: -1)
        switchingGraph()
        switchingGraphScale()
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
    class weekBarChartFirstHalfFormatter: NSObject, IAxisValueFormatter {
        private var week: [String]! = []
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            for i in 1...10 {
                week.append(String(i))
            }
            return week[Int(value)]
        }
    }
    class weekBarChartMiddleHalfFormatter: NSObject, IAxisValueFormatter {
        private var week: [String]! = []
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            for i in 11...20 {
                week.append(String(i))
            }
            return week[Int(value)]
        }
    }
    class weekBarChartSecondHalfFormatter: NSObject, IAxisValueFormatter {
        private var week: [String]! = []
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            for i in 21...31 {
                week.append(String(i))
            }
            return week[Int(value)]
        }
    }
    // セグメントが「月」選択時
    class monthBarChartFormatter: NSObject, IAxisValueFormatter {
        private var month: [String]! = []
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            for i in 1...31 {
                month.append(String(i))
            }
            return month[Int(value)]
        }
    }
}

// ラベル用
extension RecordViewController {
    // トータルポモドーロタイムを表示するための処理
    func putGraphLabel(numberChangeReference: Int) {
        changeReference += numberChangeReference
//        let oneHourSeconds: Int = 3600
        switch segment.selectedSegmentIndex {
        case 0:
            totalTimeLabel.text = String("\(GraphDataModel.graphDataModel.graphTimeLabel(segmentIndex: segment.selectedSegmentIndex, referenceType: changeReference))h")
            dateLabel.text = GraphDataModel.graphDataModel.graphDateLabel(segmentIndex: segment.selectedSegmentIndex, referenceType: changeReference)
        case 1:
            if changeReference == 1 {
                totalTimeLabel.text = String("\(GraphDataModel.graphDataModel.graphTimeLabel(segmentIndex: segment.selectedSegmentIndex, referenceType: changeReference))h")
                dateLabel.text = "\(DateModel.dateModel.currentMonth())/1 ~ \(DateModel.dateModel.currentMonth())/10"
            } else if changeReference == 0 {
                totalTimeLabel.text = String("\(GraphDataModel.graphDataModel.graphTimeLabel(segmentIndex: segment.selectedSegmentIndex, referenceType: changeReference))h")
                dateLabel.text = "\(DateModel.dateModel.currentMonth())/11 ~ \(DateModel.dateModel.currentMonth())/20"
            } else if changeReference == -1 {
                totalTimeLabel.text = String("\(GraphDataModel.graphDataModel.graphTimeLabel(segmentIndex: segment.selectedSegmentIndex, referenceType: changeReference))h")
                dateLabel.text = "\(DateModel.dateModel.currentMonth())/21 ~ \(DateModel.dateModel.currentMonth())/\(DateModel.dateModel.lastDate())"
            }
        case 2:
            totalTimeLabel.text = String("\(GraphDataModel.graphDataModel.graphTimeLabel(segmentIndex: segment.selectedSegmentIndex, referenceType: changeReference))h")
            dateLabel.text = "\(DateModel.dateModel.currentMonth())月"
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
                chevronRightButton.isEnabled = true
            } else if dateLabel.text == "\(DateModel.dateModel.currentMonth())/\(DateModel.dateModel.todayDate())" {
                chevronLeftButton.isEnabled = true
                chevronRightButton.isEnabled = false
            } else {
                chevronLeftButton.isEnabled = true
                chevronRightButton.isEnabled = true
            }
        case 1:
            if changeReference == 1 {
                chevronLeftButton.isEnabled = false
                chevronRightButton.isEnabled = true
            } else if changeReference == -1 {
                chevronLeftButton.isEnabled = true
                chevronRightButton.isEnabled = false
            } else {
                chevronLeftButton.isEnabled = true
                chevronRightButton.isEnabled = true
            }
        case 2:
            chevronLeftButton.isEnabled = false
            chevronRightButton.isEnabled = false
        default: break
        }
    }
}

// グラフ用
extension RecordViewController {
    // セグメントに合わせて、グラフの表示を切り替える
    func switchingGraph() {
        switch segment.selectedSegmentIndex {
        case 0:
            GraphDataModel.graphDataModel.graphTimeCalc(segmentIndex: segment.selectedSegmentIndex, referenceType: changeReference)
            rawData = GraphDataModel.graphDataModel.calcData
        case 1:
            GraphDataModel.graphDataModel.graphTimeCalc(segmentIndex: segment.selectedSegmentIndex, referenceType: changeReference)
            rawData = GraphDataModel.graphDataModel.calcData
        case 2:
            GraphDataModel.graphDataModel.graphTimeCalc(segmentIndex: segment.selectedSegmentIndex, referenceType: changeReference)
            rawData = GraphDataModel.graphDataModel.calcData
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
            barChartView.xAxis.labelCount = 10
            if changeReference == 1 {
                barChartView.xAxis.valueFormatter = weekBarChartFirstHalfFormatter()
            } else if changeReference == 0 {
                barChartView.xAxis.valueFormatter = weekBarChartMiddleHalfFormatter()
            } else if changeReference == -1 {
                barChartView.xAxis.valueFormatter = weekBarChartSecondHalfFormatter()
            }
        case 2:
            barChartView.xAxis.enabled = true
            barChartView.xAxis.labelCount = 10
            barChartView.xAxis.valueFormatter = monthBarChartFormatter()
        default: break
        }
    }
}

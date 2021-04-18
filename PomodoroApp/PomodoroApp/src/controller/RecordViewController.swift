//
//  RecordViewController.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/04/17.
//

import UIKit
import Charts

class RecordViewController: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var barChartView: BarChartView!
    var backTimerScreenButton: UIBarButtonItem!
    
    private var rawData = [10.0, 12.1, 13.2, 10.0, 12.1, 13.2, 10.0, 12.1, 13.2, 10.0, 12.1, 13.2]

    override func viewDidLoad() {
        super.viewDidLoad()
        displayGraph()
        showGraph()
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
        switch segment.selectedSegmentIndex {
        case 0:
            rawData = [5]
        case 1:
            rawData = [10, 20, 30, 40, 50, 10, 20]
        case 2:
            rawData = [
                15, 40, 10, 20, 30, 40, 50, 10, 20, 10,
                15, 40, 10, 20, 30, 40, 50, 10, 20, 10,
                15, 40, 10, 20, 30, 40, 50, 10, 20, 10
            ]
        default: break
        }
        displayGraph()
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
}

// 画面の見た目
extension RecordViewController {
    
    func showGraph() {
        barChartView.legend.enabled = false
        // X座標軸の設定
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelTextColor = .systemGray
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.labelCount = 12
        barChartView.xAxis.granularity = 1.0
        barChartView.xAxis.valueFormatter = BarChartFormatter()
    
        // Y座標軸の設定
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.drawZeroLineEnabled = true
        barChartView.leftAxis.zeroLineColor = .systemGray
        barChartView.leftAxis.labelTextColor = .systemGray
        barChartView.leftAxis.gridColor = .systemGray
        barChartView.leftAxis.drawAxisLineEnabled = false
    }
    
    //x軸のラベルを設定する
    class BarChartFormatter: NSObject, IAxisValueFormatter {
        let months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return months[Int(value)]
        }
    }
}



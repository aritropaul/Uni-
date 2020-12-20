//
//  GradeDetailTableViewController.swift
//  VIT
//
//  Created by Aritro Paul on 26/08/20.
//

import UIKit
import Charts

private class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return -10
    }
}

class GradeDetailTableViewController: UITableViewController {

    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var gradeGraphView: UIView!
    @IBOutlet weak var graphDescLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    var gradeDetails : Grade!
    var marksList : [Mark]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gradeDetails.title.abbr()
        gradeLabel.text = gradeDetails.grade
        totalLabel.text = "\(gradeDetails.grandTotal)"
        marksList = gradeDetails.marks
        setupChartView()
        chartView.noDataText = "No data available for this subject"
        if gradeDetails.gradingType == "RG"{
            makeChart(data: getPoints(mean: gradeDetails.range!["mean"]!, sd: gradeDetails.range!["standardDeviation"]!))
        }
        else {
            graphDescLabel.text = ""
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marksList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradeMarkCell", for: indexPath) as! GradeMarksTableViewCell
        guard let marksList = marksList else { return UITableViewCell() }
        let item = marksList[indexPath.row]
        cell.setMarks(for: item.title, marksGiven: item.actualMarks, maxMarks: item.maxMarks)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension GradeDetailTableViewController {
    
    func normalDistribution(μ:Double, σ:Double, x: Double) -> Double {
        let a = exp( -1 * pow(x-μ, 2) / ( 2 * pow(σ,2) ) )
        let b = σ * sqrt( 2 * Double.pi )
        return a / b
    }

    
    func getPoints(mean: Double, sd: Double) -> [Double] {
        var yPoints = [Double]()
        for x in 50 ... 100 {
            let y = normalDistribution(μ: mean, σ: sd, x: Double(x))
            yPoints.append(y)
        }
        return yPoints
    }
    
    func setupChartView() {
        chartView.drawGridBackgroundEnabled = false
        chartView.legend.enabled = false
        chartView.xAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.animate(xAxisDuration: 2)
        chartView.animate(yAxisDuration: 2)
    }
    
    func makeChart(data: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
                
        for i in 0..<data.count {
            let dataEntry = ChartDataEntry(x: Double(i+50), y: Double(data[i]))
            if data[i] > 0.0 {
                dataEntries.append(dataEntry)
            }
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "")
        let lineChartData = LineChartData()
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.cubicIntensity = 0.25
        lineChartDataSet.fillFormatter = CubicLineSampleFillFormatter()
        lineChartDataSet.lineWidth = 2
        lineChartDataSet.setColor(UIColor.proBlue)
        lineChartDataSet.fillAlpha = 1
        lineChartDataSet.drawFilledEnabled = true
        let gradientColors = [UIColor.proBlue.cgColor, UIColor.proBlueHalf.cgColor, UIColor.clear.cgColor]
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors as CFArray, locations: nil)
        lineChartDataSet.fill = Fill(linearGradient: gradient!, angle: -90)
        lineChartDataSet.drawValuesEnabled = false
        lineChartData.addDataSet(lineChartDataSet)
        let normalMark = normalDistribution(μ: gradeDetails.range!["mean"]!, σ: gradeDetails.range!["standardDeviation"]!, x: Double(gradeDetails.grandTotal))
        let selfMark = ChartDataEntry(x: Double(gradeDetails.grandTotal), y: normalMark)
        let markDataSet = LineChartDataSet([selfMark])
        markDataSet.circleHoleColor = .white
        markDataSet.circleColors = [.white]
        markDataSet.circleRadius = 5
        markDataSet.drawValuesEnabled = false
        lineChartData.addDataSet(markDataSet)
        chartView.data = lineChartData
    }
}

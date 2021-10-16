//
//  pieViewController.swift
//  GestionCETAC
//
//  Created by Diógenes Grajales Corona on 16/10/21.
//

import UIKit
import Charts
import TinyConstraints

class pieViewController: UIViewController {

    @IBOutlet weak var pieView: UIView!
    
    lazy var sesionesChart:PieChartView = {
        let ChartView = PieChartView()
        return ChartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieView.addSubview(sesionesChart)
        sesionesChart.center(in: pieView)
        sesionesChart.width(to: pieView)
        sesionesChart.heightToWidth(of: pieView)
        sesionesChartActualiza()
       
        // Do any additional setup after loading the view.
    }
    
    func sesionesChartActualiza(){
        let punto1 = PieChartDataEntry(value:1)
        let punto2 = PieChartDataEntry(value:4)
        let punto3 = PieChartDataEntry(value:3)
        let punto4 = PieChartDataEntry(value:2)
        
        var sesionesDataSet = PieChartDataSet(entries: [punto1,punto2,punto3,punto4])
        var data = PieChartData(dataSet: sesionesDataSet)
        
        sesionesChart.data = data
        sesionesChart.chartDescription?.text = "Sesiones por usuario"
        sesionesChart.notifyDataSetChanged()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

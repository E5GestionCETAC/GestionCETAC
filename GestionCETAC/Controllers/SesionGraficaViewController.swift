//
//  SesionGraficaViewController.swift
//  GestionCETAC
//
//  Created by user195142 on 10/14/21.
//

import UIKit
import Charts
import TinyConstraints

class SesionGraficaViewController: UIViewController
{
    var sesionControlador = sesionController()
    var topFives: [(key:String, value:Int)]?
    @IBOutlet weak var pieVista: UIView!
    lazy var topFive: PieChartView = {
        let ChartView = PieChartView()
        return ChartView
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        pieVista.addSubview(topFive)
        topFive.center(in: pieVista)
        topFive.width(to: pieVista)
        topFive.heightToWidth(of: pieVista)
        sesionControlador.fetchTopFiveMotivos(){(result) in
            switch result{
            case.success(let motivos): self.topFiveUpdate(motivos)
            case.failure(let error): print(error)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func topFiveUpdate(_ motivos:[(key:String, value:Int)]){
        //var topFive = fetchTopMotivos()
        var total = 0
        let sliceOne = PieChartDataEntry(value: Double(motivos[0].value), label:motivos[0].key )
        print(motivos[0].key)
        let sliceTwo = PieChartDataEntry(value: Double(motivos[1].value), label:motivos[1].key )
        print(motivos[1].key)
        let sliceThree = PieChartDataEntry(value: Double(motivos[2].value), label:motivos[2].key )
        print(motivos[2].key)
        let sliceFour = PieChartDataEntry(value: Double(motivos[3].value), label:motivos[3].key)
        print(motivos[3].key)
        let sliceFive = PieChartDataEntry(value: Double(motivos[4].value), label:motivos[4].key )
        print(motivos[4].key)
        for i in 5..<motivos.count{
            total += motivos[i].value
        }
        
        let sliceSix = PieChartDataEntry(value: Double(total), label:"otros" )
        print(motivos[5].key)


        let dataSet = PieChartDataSet(entries:[sliceOne,sliceTwo,sliceThree,sliceFour,sliceFive,sliceSix], label: "Top 5 Motivos")
        
        dataSet.colors = ChartColorTemplates.pastel()
        let data = PieChartData(dataSet:dataSet)
        topFive.data = data
        topFive.chartDescription?.text = "Motivos mas comunes por consulta"
        topFive.chartDescription?.textColor = UIColor.blue
        topFive.legend.textColor = UIColor.blue
        //This must stay at end of function
        topFive.notifyDataSetChanged()
    }
    
}

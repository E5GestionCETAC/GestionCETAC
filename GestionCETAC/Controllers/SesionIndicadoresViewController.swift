//
//  SesionIndicadoresViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 18/10/21.
//

import UIKit
import Charts
import TinyConstraints

class SesionIndicadoresViewController: UIViewController
{
    var sesionControlador = sesionController()
    var topFives: [(key:String, value:Int)]?
    @IBOutlet weak var pieVistaMotivos: UIView!
    @IBOutlet weak var pieVistaIntervenciones: UIView!
    
    lazy var topFiveMotivos: PieChartView = {
        let ChartView = PieChartView()
        return ChartView
    }()
    
    lazy var topFiveIntervenciones: PieChartView = {
        let ChartView = PieChartView()
        return ChartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieVistaMotivos.addSubview(topFiveMotivos)
        topFiveMotivos.center(in: pieVistaMotivos)
        topFiveMotivos.width(to: pieVistaMotivos)
        topFiveMotivos.heightToWidth(of: pieVistaMotivos)
        
        pieVistaIntervenciones.addSubview(topFiveIntervenciones)
        topFiveIntervenciones.center(in: pieVistaIntervenciones)
        topFiveIntervenciones.width(to: pieVistaIntervenciones)
        topFiveIntervenciones.heightToWidth(of: pieVistaIntervenciones)
        sesionControlador.fetchTopFiveMotivos(){(result) in
            switch result{
            case.success(let motivos): self.topFiveMotivosUpdate(motivos)
            case.failure(let error): print(error)
            }
        }
        
        sesionControlador.fetchTopFiveIntervenciones(){(result) in
            switch result{
            case.success(let intervenciones): self.topFiveIntervencionesUpdate(intervenciones)
            case.failure(let error): print(error)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func topFiveMotivosUpdate(_ motivos:[(key:String, value:Int)]){
        //var topFive = fetchTopMotivos()
        var total = 0
        let sliceOne = PieChartDataEntry(value: Double(motivos[0].value), label:motivos[0].key )
        let sliceTwo = PieChartDataEntry(value: Double(motivos[1].value), label:motivos[1].key )
        let sliceThree = PieChartDataEntry(value: Double(motivos[2].value), label:motivos[2].key )
        let sliceFour = PieChartDataEntry(value: Double(motivos[3].value), label:motivos[3].key)
        let sliceFive = PieChartDataEntry(value: Double(motivos[4].value), label:motivos[4].key )
        for i in 5..<motivos.count{
            total += motivos[i].value
        }
        
        let sliceSix = PieChartDataEntry(value: Double(total), label:"Otros" )
        let dataSet = PieChartDataSet(entries:[sliceOne,sliceTwo,sliceThree,sliceFour,sliceFive,sliceSix], label: "Top 5 Motivos")
        
        dataSet.colors = ChartColorTemplates.pastel()
        let data = PieChartData(dataSet:dataSet)
        topFiveMotivos.data = data
        topFiveMotivos.notifyDataSetChanged()
    }
    
    func topFiveIntervencionesUpdate(_ intervenciones:[(key:String, value:Int)]){
        //var topFive = fetchTopMotivos()
        var total = 0
        let sliceOne = PieChartDataEntry(value: Double(intervenciones[0].value), label:intervenciones[0].key )
        let sliceTwo = PieChartDataEntry(value: Double(intervenciones[1].value), label:intervenciones[1].key )
        let sliceThree = PieChartDataEntry(value: Double(intervenciones[2].value), label:intervenciones[2].key )
        let sliceFour = PieChartDataEntry(value: Double(intervenciones[3].value), label:intervenciones[3].key)
        let sliceFive = PieChartDataEntry(value: Double(intervenciones[4].value), label:intervenciones[4].key )
        for i in 5..<intervenciones.count{
            total += intervenciones[i].value
        }
        
        let sliceSix = PieChartDataEntry(value: Double(total), label:"Otros" )
        let dataSet = PieChartDataSet(entries:[sliceOne,sliceTwo,sliceThree,sliceFour,sliceFive,sliceSix], label: "Top 5 Intervenciones")
        
        dataSet.colors = ChartColorTemplates.joyful()
        let data = PieChartData(dataSet:dataSet)
        topFiveIntervenciones.data = data
        topFiveIntervenciones.notifyDataSetChanged()
    }
    
}

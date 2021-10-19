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
    let colors = [NSUIColor(red: 121/255, green: 173/255, blue: 220/255, alpha: 1),NSUIColor(red: 255/255, green: 192/255, blue: 159/255, alpha: 1),NSUIColor(red: 255/255, green: 238/255, blue: 147/255, alpha: 1),NSUIColor(red: 252/255, green: 245/255, blue: 199/255, alpha: 1),NSUIColor(red: 160/255, green: 206/255, blue: 217/255, alpha: 1),NSUIColor(red: 137/255, green: 247/255, blue: 182/255, alpha: 1)]
    var sesionControlador = sesionController()
    var topFives: [(key:String, value:Int)]?
    @IBOutlet weak var pieVistaMotivos: UIView!
    @IBOutlet weak var pieVistaIntervenciones: UIView!

    
    lazy var topFiveMotivos: PieChartView = {
        let ChartViewMotivos = PieChartView()
        ChartViewMotivos.holeColor = .clear
        ChartViewMotivos.legend.enabled = false
        return ChartViewMotivos
    }()
    
    lazy var topFiveIntervenciones: PieChartView = {
        let ChartViewIntervenciones = PieChartView()
        ChartViewIntervenciones.holeColor = .clear
        ChartViewIntervenciones.legend.enabled = false
        return ChartViewIntervenciones
    }()
    
    lazy var indicadores: BarChartView = {
        let ChartViewIndicadores = BarChartView()
        return ChartViewIndicadores
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
    }
    
    func topFiveMotivosUpdate(_ motivos:[(key:String, value:Int)]){
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 100
        var total:Double = 0
        for i in 0..<motivos.count{
            total += Double(motivos[i].value)
        }
        let sliceOne = PieChartDataEntry(value: Double(motivos[0].value)/total, label:motivos[0].key )
        let sliceTwo = PieChartDataEntry(value: Double(motivos[1].value)/total, label:motivos[1].key )
        let sliceThree = PieChartDataEntry(value: Double(motivos[2].value)/total, label:motivos[2].key )
        let sliceFour = PieChartDataEntry(value: Double(motivos[3].value)/total, label:motivos[3].key)
        let sliceFive = PieChartDataEntry(value: Double(motivos[4].value)/total, label:motivos[4].key )
        
        let sliceSix = PieChartDataEntry(value: (Double(total) - Double(motivos[0].value) - Double(motivos[1].value) - Double(motivos[2].value) - Double(motivos[3].value) - Double(motivos[4].value))/total, label:"Otros" )
        let dataSet = PieChartDataSet(entries:[sliceOne,sliceTwo,sliceThree,sliceFour,sliceFive,sliceSix])
        dataSet.colors = colors
        dataSet.valueFont = .boldSystemFont(ofSize: 14)
        dataSet.valueTextColor = .darkGray
        dataSet.entryLabelFont = .boldSystemFont(ofSize: 14)
        dataSet.entryLabelColor = .darkGray
        let data = PieChartData(dataSet:dataSet)
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        topFiveMotivos.data = data
        topFiveMotivos.notifyDataSetChanged()
    }
    
    func topFiveIntervencionesUpdate(_ intervenciones:[(key:String, value:Int)]){
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 100
        var total:Double = 0
        for i in 0..<intervenciones.count{
            total += Double(intervenciones[i].value)
        }
        let sliceOne = PieChartDataEntry(value: Double(intervenciones[0].value)/total, label:intervenciones[0].key )
        let sliceTwo = PieChartDataEntry(value: Double(intervenciones[1].value)/total, label:intervenciones[1].key )
        let sliceThree = PieChartDataEntry(value: Double(intervenciones[2].value)/total, label:intervenciones[2].key )
        let sliceFour = PieChartDataEntry(value: Double(intervenciones[3].value)/total, label:intervenciones[3].key)
        let sliceFive = PieChartDataEntry(value: Double(intervenciones[4].value)/total, label:intervenciones[4].key )
        
        let sliceSix = PieChartDataEntry(value: (Double(total) - Double(intervenciones[0].value) - Double(intervenciones[1].value) - Double(intervenciones[2].value) - Double(intervenciones[3].value) - Double(intervenciones[4].value))/total, label:"Otros" )
        let dataSet = PieChartDataSet(entries:[sliceOne,sliceTwo,sliceThree,sliceFour,sliceFive,sliceSix])
        
        dataSet.colors = colors
        dataSet.valueFont = .boldSystemFont(ofSize: 14)
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        dataSet.valueTextColor = .darkGray
        dataSet.entryLabelFont = .boldSystemFont(ofSize: 14)
        dataSet.entryLabelColor = .darkGray
        let data = PieChartData(dataSet:dataSet)
        topFiveIntervenciones.data = data
        topFiveIntervenciones.notifyDataSetChanged()
    }
}

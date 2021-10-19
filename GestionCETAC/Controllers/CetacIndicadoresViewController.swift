//
//  CetacIndicadoresViewController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 17/10/21.
//

import UIKit
import Charts
import TinyConstraints

class CetacIndicadoresViewController: UIViewController {

    //Controladores
    let usuarioControlador = usuarioController()
    let cetacUsuariosControlador = cetacUserController()
    let sesionControlador = sesionController()
    // End Controladores
    let months = ["Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic",]
    var cetacUsersID = [String]()
    var dataDictionary:[String:Int] = [:]
    var entries = [BarChartDataEntry]()
    weak var axisFormatDelegate:IAxisValueFormatter?
    @IBOutlet weak var vistaBarras: UIView!
    
    @IBOutlet weak var vistaLinea2: UIView!
    @IBOutlet weak var vistaLinea3: UIView!
    
    @IBOutlet weak var vistaBarras2: UIView!
    lazy var usuariosPorTanatologo:BarChartView = {
        let barChartView = BarChartView()
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.labelFont = .boldSystemFont(ofSize: 14)
        barChartView.leftAxis.granularity = 1
        barChartView.leftAxis.labelFont = .boldSystemFont(ofSize: 14)
        barChartView.leftAxis.drawGridLinesEnabled = false
        return barChartView
    }()
    
    lazy var cuotaPorAno:LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 14)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.setLabelCount(12, force: false)
        lineChartView.rightAxis.enabled = false
        
        lineChartView.leftAxis.labelFont = .boldSystemFont(ofSize: 14)

        return lineChartView
    }()
    
    lazy var indicadores: BarChartView = {
        let ChartViewIndicadores = BarChartView()
        ChartViewIndicadores.xAxis.drawGridLinesEnabled = false
        ChartViewIndicadores.rightAxis.enabled = false
        ChartViewIndicadores.xAxis.labelFont = .boldSystemFont(ofSize: 14)
        ChartViewIndicadores.leftAxis.granularity = 1
        ChartViewIndicadores.leftAxis.labelFont = .boldSystemFont(ofSize: 14)
        ChartViewIndicadores.leftAxis.drawGridLinesEnabled = false
        return ChartViewIndicadores
    }()
    
    lazy var cuotaUltimaSemana:LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 14)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.setLabelCount(12, force: false)
        lineChartView.rightAxis.enabled = false

        lineChartView.leftAxis.labelFont = .boldSystemFont(ofSize: 14)
        
        return lineChartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        axisFormatDelegate = self
        vistaBarras.addSubview(usuariosPorTanatologo)
        usuariosPorTanatologo.center(in: vistaBarras)
        usuariosPorTanatologo.width(to: vistaBarras)
        usuariosPorTanatologo.heightToWidth(of: vistaBarras)
        
        vistaLinea3.addSubview(cuotaPorAno)
        cuotaPorAno.center(in: vistaLinea3)
        cuotaPorAno.width(to: vistaLinea3)
        cuotaPorAno.heightToWidth(of: vistaLinea3)
        
        vistaLinea2.addSubview(cuotaUltimaSemana)
        cuotaUltimaSemana.center(in: vistaLinea2)
        cuotaUltimaSemana.width(to: vistaLinea2)
        cuotaUltimaSemana.heightToWidth(of: vistaLinea2)
        
        vistaBarras2.addSubview(indicadores)
        indicadores.center(in: vistaBarras2)
        indicadores.width(to: vistaBarras2)
        indicadores.heightToWidth(of: vistaBarras2)
        
        usuarioControlador.fetchNumberOfUsersByTanatologo(){(result) in
            switch result{
            case .success(let dicc): self.getCetacUsers(dicc)
            case.failure(let error): print(error)
            }
        }
        
        sesionControlador.getCuotaRecuperacionByMonth(){(result)in
            switch result{
            case .success(let tupla):self.updateLineChart3(tupla)
            case .failure(let error):print(error)
            }
        }
        
        sesionControlador.getCuotaRecuperacionByLastWeek(){(result)in
        switch result{
        case .success(let tupla):self.updateLineChart2(tupla)
        case .failure(let error):print(error)
            }
        }
        
        sesionControlador.fetchIndicadoresServicios(){(result) in
            switch result{
            case.success(let tuple):self.updateBarChart2(tuple)
            case.failure(let error):print(error)
            }
        }
    }
    
    func updateLineChart2(_ tupla:[(key:String, value:Float)]){
        var days = [String]()
        var entriesLineChart = [ChartDataEntry]()
        for i in 0..<tupla.count{
            let entry = ChartDataEntry(x: Double(i), y: Double(tupla[i].value))
            days.append(tupla[i].key)
            entriesLineChart.append(entry)
        }
        
        let dataset = LineChartDataSet(entries: entriesLineChart)
        dataset.mode = .cubicBezier
        let color = NSUIColor(red: 232/255, green: 223/255, blue: 245/255, alpha: 1)
        dataset.lineWidth = 3
        dataset.setColor(color)
        dataset.fill = Fill(color: color)
        dataset.fillAlpha = 0.7
        dataset.drawFilledEnabled = true
        dataset.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataset.valueFont = .systemFont(ofSize: 14)
        dataset.circleColors = [NSUIColor(red: 160/255, green: 231/255, blue: 229/255, alpha: 1)]
        let data = LineChartData(dataSet: dataset)
        cuotaUltimaSemana.data = data
        cuotaUltimaSemana.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        cuotaUltimaSemana.xAxis.granularity = 1
        cuotaUltimaSemana.notifyDataSetChanged()
    }
    
    func updateLineChart3(_ tupla:[(key:String, value:Float)]){
        var entriesLineChart = [ChartDataEntry]()
        for i in 0..<tupla.count{
            let entry = ChartDataEntry(x: Double(i), y: Double(tupla[i].value))
            entriesLineChart.append(entry)
        }
        
        let dataset = LineChartDataSet(entries: entriesLineChart)
        dataset.mode = .cubicBezier
        let color = NSUIColor(red: 232/255, green: 223/255, blue: 245/255, alpha: 1)
        dataset.lineWidth = 3
        dataset.setColor(color)
        dataset.fill = Fill(color: color)
        dataset.fillAlpha = 0.7
        dataset.drawFilledEnabled = true
        dataset.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataset.valueFont = .systemFont(ofSize: 14)
        dataset.circleColors = [NSUIColor(red: 160/255, green: 231/255, blue: 229/255, alpha: 1)]
        let data = LineChartData(dataSet: dataset)
        cuotaPorAno.data = data
        cuotaPorAno.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        cuotaPorAno.xAxis.granularity = 1
        cuotaPorAno.notifyDataSetChanged()
    }
    
    func updateBarChart(){
        let dataSet = BarChartDataSet(entries: self.entries, label: "Usuarios por tanatólogo")
        dataSet.colors = [NSUIColor(red: 255/255, green: 192/255, blue: 159/255, alpha: 1)]
        dataSet.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataSet.valueFont = .systemFont(ofSize: 14)
        let data = BarChartData(dataSet: dataSet)
        usuariosPorTanatologo.data = data
        
        let xAxisValue = usuariosPorTanatologo.xAxis
        xAxisValue.valueFormatter = axisFormatDelegate
        usuariosPorTanatologo.xAxis.granularity = 1
        usuariosPorTanatologo.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        usuariosPorTanatologo.notifyDataSetChanged()
    }
    
    func updateBarChart2(_ tuple:[(key:String, value:Int)]){
        var servicios = [String]()
        var entriesServicios = [BarChartDataEntry]()
        for i in 0..<tuple.count{
            let entry = BarChartDataEntry(x: Double(i), y: Double(tuple[i].value))
            servicios.append(tuple[i].key)
            entriesServicios.append(entry)
        }
        
        let dataset = BarChartDataSet(entries: entriesServicios, label: "Servicios")
        dataset.colors = [NSUIColor(red: 255/255, green: 238/255, blue: 147/255, alpha: 1)]
        dataset.valueFormatter = DefaultValueFormatter(decimals: 0)
        dataset.valueFont = .systemFont(ofSize: 14)
        let data = BarChartData(dataSet: dataset)
        indicadores.data = data
        indicadores.xAxis.valueFormatter = IndexAxisValueFormatter(values: servicios)
        indicadores.xAxis.granularity = 1
        indicadores.notifyDataSetChanged()
    }
    
    func getCetacUsers(_ dictionary: Dictionary<String, Int>){
        for (cetacUserID, value) in dictionary{
            cetacUsersID.append(cetacUserID)
            cetacUsuariosControlador.getUserInfo(currentUserUID: cetacUserID){(result) in
                switch result{
                case .success(let cetacUser): self.setInfo(cetacUser.nombre, value)
                case .failure(let error): print(error)
                }
            }
        }
    }
    
    func setInfo(_ name: String, _ value:Int){
        dataDictionary[name] = value
        if cetacUsersID.count == dataDictionary.count {
            setData()
        }
    }
    
    func setData(){
        var i:Double = 0
        for (_, value) in dataDictionary{
            let entry = BarChartDataEntry(x: i, y: Double(value))
            entries.append(entry)
            i += 1
        }
        updateBarChart()
    }
}

extension CetacIndicadoresViewController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return Array(dataDictionary)[Int(value)].key
    }
}

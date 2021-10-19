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
    // End Controladores
    var cetacUsersID = [String]()
    var dataDictionary:[String:Int] = [:]
    var entries = [BarChartDataEntry]()
    weak var axisFormatDelegate:IAxisValueFormatter?
    @IBOutlet weak var vistaBarras: UIView!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        axisFormatDelegate = self
        vistaBarras.addSubview(usuariosPorTanatologo)
        usuariosPorTanatologo.center(in: vistaBarras)
        usuariosPorTanatologo.width(to: vistaBarras)
        usuariosPorTanatologo.heightToWidth(of: vistaBarras)
        usuarioControlador.fetchNumberOfUsersByTanatologo(){(result) in
            switch result{
            case .success(let dicc): self.getCetacUsers(dicc)
            case.failure(let error): print(error)
            }
        }
        // Do any additional setup after loading the view.
    }
    // [key: "Masculino", value: 4, [KEY: "fEMENINO" VALUE:5]]
    
    func updateChart(){
        let dataSet = BarChartDataSet(entries: self.entries, label: "Usuarios por tanatólogo")
        dataSet.colors = ChartColorTemplates.colorful()
        let data = BarChartData(dataSet: dataSet)
        usuariosPorTanatologo.data = data
        
        let xAxisValue = usuariosPorTanatologo.xAxis
        xAxisValue.valueFormatter = axisFormatDelegate
        usuariosPorTanatologo.xAxis.granularity = 1
        usuariosPorTanatologo.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        usuariosPorTanatologo.notifyDataSetChanged()
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
        updateChart()
    }
}

extension CetacIndicadoresViewController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return Array(dataDictionary)[Int(value)].key
    }
}

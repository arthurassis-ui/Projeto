import Foundation
protocol Manutencao {
    var nomeMaquina: String { get }
    var id: String { get }
    var historicoMaquina: String { get set }
    
    func realizarManutencao(data: String, problema: TipoProblema) -> Bool
    func estaEmDia() -> Bool
}

enum TipoProblema: String {
    case estrutura = "estrutura"
    case cabo = "cabo"
    case banco = "banco"
    case sistema = "sistema"
    case geral = "problema geral"
}

enum EstadoEquipamento {
    case funcionando
    case defeituoso
}

enum TipoEquipamento: String {
    case peito = "Peito"
    case perna = "Perna"
    case costas = "Costas"
    case braco = "Braço"
}

class EquipamentoAcademia: Manutencao {
    let nomeMaquina: String
    let id: String
    var historicoMaquina: String
    var estado: EstadoEquipamento
    let tipo: TipoEquipamento
    
    init(nomeMaquina: String, id: String, tipo: TipoEquipamento, estado: EstadoEquipamento) {
        self.nomeMaquina = nomeMaquina
        self.id = id
        self.tipo = tipo
        self.estado = estado
        self.historicoMaquina = ""
    }
    
    func realizarManutencao(data: String, problema: TipoProblema) -> Bool {
        if estado == .defeituoso {
            print("Falha: equipamento \(id) está defeituoso")
            return false
        }
        
        let registro = "[\(id)] \(nomeMaquina) - \(tipo.rawValue) | \(data) | Problema no(a) \(problema.rawValue)\n"
        historicoMaquina += registro
        
        print("Manutenção realizada: problema no(a) \(problema.rawValue)")
        return true
    }
    
    func estaEmDia() -> Bool {
        return estado == .funcionando
    }
}

print("========== TESTE MANUTENÇÃO ==========")

let eq1 = EquipamentoAcademia(nomeMaquina: "Supino", id: "EQ001", tipo: .peito, estado: .funcionando)
let eq2 = EquipamentoAcademia(nomeMaquina: "Leg Press", id: "EQ002", tipo: .perna, estado: .defeituoso)

let r1 = eq1.realizarManutencao(data: "28/04/2026", problema: .estrutura)
if r1 {
    print("Operação concluída")
} else {
    print("Operação falhou")
}

let r2 = eq1.realizarManutencao(data: "28/04/2026", problema: .sistema)
if r2 {
    print("Operação concluída")
} else {
    print("Operação falhou")
}

let r3 = eq2.realizarManutencao(data: "28/04/2026", problema: .cabo)
if r3 {
    print("Operação concluída")
} else {
    print("Operação falhou")
}

print("\nHistórico do equipamento 1:")
print(eq1.historicoMaquina)


//teste como se fosse um aviao como eu falei na aula
protocol Manutencao {
    var nomeMaquina: String { get }
    var id: String { get }
    var historicoMaquina: String { get set }
    
    func realizarManutencao(data: String, problema: TipoProblema) -> Bool
    func estaEmDia() -> Bool
}

enum TipoProblema: String {
    case asaEsquerda = "asa esquerda"
    case bico = "bico"
    case cauda = "cauda"
    case sistema = "sistema"
    case geral = "problema geral"
}

enum EstadoEquipamento {
    case funcionando
    case defeituoso
}

enum TipoAeronave: String {
    case carga = "Avião de carga"
    case transporte = "Avião de transporte"
    case guerra = "Avião de guerra"
    case executivo = "Avião executivo"
}

class Aviao: Manutencao {
    let nomeMaquina: String
    let id: String
    var historicoMaquina: String
    var estado: EstadoEquipamento
    let tipo: TipoAeronave
    
    init(nomeMaquina: String, id: String, tipo: TipoAeronave, estado: EstadoEquipamento) {
        self.nomeMaquina = nomeMaquina
        self.id = id
        self.tipo = tipo
        self.estado = estado
        self.historicoMaquina = ""
    }
    
    func realizarManutencao(data: String, problema: TipoProblema) -> Bool {
        if estado == .defeituoso {
            print("Falha: equipamento \(id) está defeituoso")
            return false
        }
        
        let registro = "[\(id)] \(nomeMaquina) - \(tipo.rawValue) | \(data) | Problema no(a) \(problema.rawValue)\n"
        historicoMaquina += registro
        
        print("Manutenção realizada: problema no(a) \(problema.rawValue)")
        return true
    }
    
    func estaEmDia() -> Bool {
        return estado == .funcionando
    }
}

print("========== TESTE MANUTENÇÃO ==========")

let aviao1 = Aviao(nomeMaquina: "Boeing 747", id: "AV001", tipo: .carga, estado: .funcionando)
let aviao2 = Aviao(nomeMaquina: "F16", id: "AV002", tipo: .guerra, estado: .defeituoso)

let resultado1 = aviao1.realizarManutencao(data: "28/04/2026", problema: .asaEsquerda)
if resultado1 {
    print("Operação concluída")
} else {
    print("Operação falhou")
}

let resultado2 = aviao1.realizarManutencao(data: "28/04/2026", problema: .sistema)
if resultado2 {
    print("Operação concluída")
} else {
    print("Operação falhou")
}

let resultado3 = aviao2.realizarManutencao(data: "28/04/2026", problema: .bico)
if resultado3 {
    print("Operação concluída")
} else {
    print("Operação falhou")
}

print("\nHistórico do avião 1:")
print(aviao1.historicoMaquina)
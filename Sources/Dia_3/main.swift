import Foundation

enum NivelExperiencia: String {
    case iniciante = "Iniciante"
    case intermediario = "Intermediário"
    case avancado = "Avançado"
}

enum CategoriaAula: String {
    case musculacao = "Musculação"
    case spinning = "Spinning"
    case yoga = "Yoga"
    case funcional = "Funcional"
    case luta = "Luta"
    case pilates = "Pilates"
}

enum TipoPlano {
    case normal
    case experimental
}

struct Horario: Equatable {
    let hora: String
}

class Plano {
    let nome: String
    let valorMensalidade: Double
    let incluiPersonal: Bool
    let limiteAulasColetivas: Int
    let duracaoMeses: Int
    let tipo: TipoPlano
    
    init(nome: String, valorMensalidade: Double, incluiPersonal: Bool, limiteAulasColetivas: Int, duracaoMeses: Int, tipo: TipoPlano) {
        self.nome = nome
        self.valorMensalidade = valorMensalidade
        self.incluiPersonal = incluiPersonal
        self.limiteAulasColetivas = limiteAulasColetivas
        self.duracaoMeses = duracaoMeses
        self.tipo = tipo
    }
}

class CatalogoPlanos {
    static let planoFitTrimestral = Plano(nome: "Plano Fit Trimestral", valorMensalidade: 130.0, incluiPersonal: true, limiteAulasColetivas: 30, duracaoMeses: 3, tipo: .normal)
    static let planoSucoMensal = Plano(nome: "Plano Suco Mensal", valorMensalidade: 150.0, incluiPersonal: false, limiteAulasColetivas: 10, duracaoMeses: 1, tipo: .normal)
    static let planoEconomicoAnual = Plano(nome: "Plano Econômico Anual", valorMensalidade: 90.0, incluiPersonal: true, limiteAulasColetivas: 40, duracaoMeses: 12, tipo: .normal)
    static let planoExperimental = Plano(nome: "Plano Experimental", valorMensalidade: 0.0, incluiPersonal: true, limiteAulasColetivas: 5, duracaoMeses: 0, tipo: .experimental)
}

class Pessoa {
    let nome: String
    let email: String
    let funcao: String
    
    init(nome: String, email: String, funcao: String) {
        self.nome = nome
        self.email = email
        self.funcao = funcao
    }
}

class Aluno: Pessoa {
    let matricula: Int
    let cpf: String
    private var plano: Plano
    private var nivel: NivelExperiencia
    private static var cpfsQueUsaramExperimental: Set<String> = []
    
    init(nome: String, email: String, matricula: Int, cpf: String, plano: Plano, nivel: NivelExperiencia) {
        self.matricula = matricula
        self.cpf = cpf
        self.nivel = nivel
        
        if plano.tipo == .experimental {
            if Aluno.cpfsQueUsaramExperimental.contains(cpf) {
                print("Você já assinou esse plano antes e não é possível assinar novamente")
                self.plano = CatalogoPlanos.planoSucoMensal
            } else {
                Aluno.cpfsQueUsaramExperimental.insert(cpf)
                self.plano = plano
            }
        } else {
            self.plano = plano
        }
        
        super.init(nome: nome, email: email, funcao: "Aluno")
    }
    func podeAgendarPersonal() -> Bool {
        return plano.incluiPersonal
    }
    func atualizarPlano(novoPlano: Plano) {
        if novoPlano.tipo == .experimental {
            if Aluno.cpfsQueUsaramExperimental.contains(self.cpf) {
                print("Você já assinou esse plano antes e não é possível assinar novamente")
                return
            }
            Aluno.cpfsQueUsaramExperimental.insert(self.cpf)
        }
        
        self.plano = novoPlano
        print("Você assinou com sucesso o \(self.plano.nome)")
    }
    
    func informacoesParaInstrutor() -> String {
        return "Nome: \(nome) | Nível: \(nivel.rawValue) | Matrícula: \(matricula)"
    }
    
    func informacoesParaAluno() -> String {
        return """
        Nome: \(nome)
        Email: \(email)
        CPF: \(cpf)
        Matrícula: \(matricula)
        Nível: \(nivel.rawValue)
        Plano: \(plano.nome)
        Valor: R$ \(plano.valorMensalidade)
        Personal: \(plano.incluiPersonal ? "Sim" : "Não")
        Limite de aulas: \(plano.limiteAulasColetivas)
        Duração: \(plano.duracaoMeses) mês(es)
        """
    }
}

class Instrutor: Pessoa {
    let especialidade: CategoriaAula
    let horario: Horario
    
    init(nome: String, email: String, especialidade: CategoriaAula, horario: Horario) {
        self.especialidade = especialidade
        self.horario = horario
        super.init(nome: nome, email: email, funcao: "Instrutor")
    }
}

class Academia {
    var instrutores: [Instrutor] = []
    
    func adicionarInstrutor(_ instrutor: Instrutor) {
        instrutores.append(instrutor)
    }
    
    func mostrarInstrutoresDisponiveis(categoria: CategoriaAula, horario: Horario) {
        let filtrados = instrutores.filter {
            $0.especialidade == categoria && $0.horario == horario
        }
        
        print("Os professores livres das \(horario.hora) de \(categoria.rawValue) são:")
        
        for (index, instrutor) in filtrados.enumerated() {
            print("\(index + 1)- \(instrutor.nome)")
        }
    }
}

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

protocol Aula {
    var nome: String { get }
    var instrutor: Instrutor { get }
    var categoria: CategoriaAula { get }
    var descricao: String { get }
}

class TurmaColetiva: Aula {
    let nome: String
    let instrutor: Instrutor
    let categoria: CategoriaAula
    let descricao: String
    let capacidadeMin: Int
    let capacidadeMax: Int
    private(set) var alunos: [Aluno] = []
    
    init(nome: String, instrutor: Instrutor, categoria: CategoriaAula, descricao: String, capacidadeMin: Int, capacidadeMax: Int) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.capacidadeMin = capacidadeMin
        self.capacidadeMax = capacidadeMax
    }
    
    func inscrever(aluno: Aluno) -> Bool {
        if alunos.contains(where: { $0.matricula == aluno.matricula }) {
            print("Aluno já está inscrito")
            return false
        }
        if alunos.count >= capacidadeMax {
            print("Turma cheia")
            return false
        }
        alunos.append(aluno)
        print("Aluno inscrito com sucesso")
        return true
    }
    
    func turmaValida() -> Bool {
        return alunos.count >= capacidadeMin
    }
}

class TreinoPersonal: Aula {
    let nome: String
    let instrutor: Instrutor
    let categoria: CategoriaAula
    let descricao: String
    let aluno: Aluno
    let horario: Horario
    
    init(nome: String, instrutor: Instrutor, categoria: CategoriaAula, descricao: String, aluno: Aluno, horario: Horario) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.aluno = aluno
        self.horario = horario
    }
}

class SistemaAcademia {
    var alunos: [Int: Aluno] = [:]
    var emails: [String: Aluno] = [:]
    var instrutores: [String: Instrutor] = [:]
    var equipamentos: [String: EquipamentoAcademia] = [:]
    var aulas: [String: Aula] = [:]
    
    func adicionarAluno(_ aluno: Aluno) {
        if alunos[aluno.matricula] != nil || emails[aluno.email] != nil {
            print("Aluno já cadastrado")
            return
        }
        alunos[aluno.matricula] = aluno
        emails[aluno.email] = aluno
        print("O aluno \(aluno.nome) foi matriculado!")
    }
    func removerAluno(matricula: Int) {
        if let aluno = alunos.removeValue(forKey: matricula) {
            print("O aluno da matricula \(aluno.matricula) foi removido!")
            emails.removeValue(forKey: aluno.email)
        } else{
            print("Erro: matricula \(matricula) não encontrada")
        }
    }
    
    func adicionarInstrutor(_ instrutor: Instrutor) {
        instrutores[instrutor.email] = instrutor
        print("O instrutor \(instrutor.nome) foi adicionado!")
        
    }
    
    func removerInstrutor(email: String) {
        if let instrutor = instrutores.removeValue(forKey: email) {
            print("O instrutor \(instrutor.nome) foi removido")
        } else {
            print("Erro: \(email) não encontrado")
        }
    }
    
    func atualizarInstrutor(email: String, novoInstrutor: Instrutor) {
        if instrutores[email] != nil {
            instrutores[email] = novoInstrutor
            print("Os instrutores foram atualizados")
        } else {
            print("erro ao atualizar instrutores")
        }
    }
    
    func alunosComPersonal() {
        var contador = 1
        for aula in aulas.values {
            if let personal = aula as? TreinoPersonal {
                print("\(contador)- O aluno \(personal.aluno.nome) está sendo instruído pelo instrutor \(personal.instrutor.nome).")
                contador += 1
            }
        }
    }

    func adicionarEquipamento(_ equipamento: EquipamentoAcademia) {
        equipamentos[equipamento.id] = equipamento
        print("O equipamento \(equipamento.nomeMaquina) foi adicionado!")
    }
    
    func removerEquipamento(id: String) {
        if let equipamento = equipamentos.removeValue(forKey: id) {
            print("O equipamento \(equipamento.nomeMaquina) foi removido")
        } else {
            print("Equipamento do ID \(id) não encontrado")
        }
    }
    func adicionarAula(_ aula: Aula) {
        aulas[aula.nome] = aula
        print("A aula de \(aula.nome) foi adicionada!")
    }
    
    func removerAula(nome: String) {
        if let aula = aulas.removeValue(forKey: nome) {
            print("A aula \(aula.nome) foi removida")
        } else {
            print("Erro: aula \(nome) não encontrada")
        }
    }
    
    func manutencaoEmLote(data: String, problema: TipoProblema) {
        var falhas: [EquipamentoAcademia] = []
        
        for equipamento in equipamentos.values {
            let resultado = equipamento.realizarManutencao(data: data, problema: problema)
            if !resultado {
                falhas.append(equipamento)
            }
        }
        
        print("Equipamentos com falha:")
        for eq in falhas {
            print("\(eq.id) - \(eq.nomeMaquina)")
        }
    }
    func agendarPersonal(nomeAula: String, instrutor: Instrutor, aluno: Aluno, horario: Horario) {

    if alunos[aluno.matricula] == nil {
        print("Aluno não cadastrado")
        return
    }

    if instrutores[instrutor.email] == nil {
        print("Instrutor não cadastrado")
        return
    }

    for aula in aulas.values {
        if let personal = aula as? TreinoPersonal {
            if personal.instrutor.email == instrutor.email && personal.horario == horario {
                print("Instrutor já possui personal nesse horário")
                return
            }
        }
    }

    if aluno.podeAgendarPersonal() {
        let aula = TreinoPersonal(
            nome: nomeAula,
            instrutor: instrutor,
            categoria: instrutor.especialidade,
            descricao: "Treino individual",
            aluno: aluno,
            horario: horario
        )
        aulas[nomeAula] = aula
        print("Personal agendado com sucesso")
    } else {
        print("Plano não permite personal")
    }
}
    func resumoSistema() {
        print("Resumo geral do sistema:")
        print("Total de alunos cadastrados: \(alunos.count)")
        print("Total de instrutores cadastrados: \(instrutores.count)")
        print("Total de equipamentos cadastrados: \(equipamentos.count)")
        print("Total de aulas cadastradas: \(aulas.count)")
    }
}

let academia = Academia()

let h1 = Horario(hora: "06:00")
let h2 = Horario(hora: "11:00")
let h3 = Horario(hora: "22:00")

academia.adicionarInstrutor(Instrutor(nome: "Carlos", email: "carlos@.com", especialidade: .musculacao, horario: h1))
academia.adicionarInstrutor(Instrutor(nome: "Bruno", email: "bruno@.com", especialidade: .musculacao, horario: h2))
academia.adicionarInstrutor(Instrutor(nome: "Rafael", email: "rafael@.com", especialidade: .musculacao, horario: h3))

academia.adicionarInstrutor(Instrutor(nome: "Ana", email: "ana@.com", especialidade: .pilates, horario: h1))
academia.adicionarInstrutor(Instrutor(nome: "Julia", email: "julia@.com", especialidade: .pilates, horario: h2))
academia.adicionarInstrutor(Instrutor(nome: "Marcos", email: "marcos@.com", especialidade: .pilates, horario: h3))

academia.adicionarInstrutor(Instrutor(nome: "Leo", email: "leo@.com", especialidade: .yoga, horario: h1))
academia.adicionarInstrutor(Instrutor(nome: "Clara", email: "clara@.com", especialidade: .yoga, horario: h2))
academia.adicionarInstrutor(Instrutor(nome: "Paulo", email: "paulo@.com", especialidade: .yoga, horario: h3))

academia.adicionarInstrutor(Instrutor(nome: "Diego", email: "diego@.com", especialidade: .spinning, horario: h1))
academia.adicionarInstrutor(Instrutor(nome: "Fernanda", email: "fernanda@.com", especialidade: .spinning, horario: h2))
academia.adicionarInstrutor(Instrutor(nome: "Gustavo", email: "gustavo@.com", especialidade: .spinning, horario: h3))

academia.adicionarInstrutor(Instrutor(nome: "Pedro", email: "p@.com", especialidade: .funcional, horario: h1))
academia.adicionarInstrutor(Instrutor(nome: "Larissa", email: "l@.com", especialidade: .funcional, horario: h2))
academia.adicionarInstrutor(Instrutor(nome: "Thiago", email: "t@.com", especialidade: .funcional, horario: h3))

academia.adicionarInstrutor(Instrutor(nome: "Victor", email: "v@.com", especialidade: .luta, horario: h1))
academia.adicionarInstrutor(Instrutor(nome: "Renan", email: "r@.com", especialidade: .luta, horario: h2))
academia.adicionarInstrutor(Instrutor(nome: "André", email: "a@.com", especialidade: .luta, horario: h3))

let aluno = Aluno(nome: "Arthur", email: "arthur@email.com", matricula: 123, cpf: "12345678900", plano: CatalogoPlanos.planoExperimental, nivel: .iniciante)

print("----- TESTE HORÁRIOS LIVRES -----")
academia.mostrarInstrutoresDisponiveis(categoria: .luta, horario: h1)

print("----- TESTE INFORMAÇÕES PARA Instrutor -----")
print(aluno.informacoesParaInstrutor())

print("----- TESTE INFORMAÇÕES PARA ALUNO -----")
print(aluno.informacoesParaAluno())

print("----- TESTE MUDAR PLANOS -----")
aluno.atualizarPlano(novoPlano: CatalogoPlanos.planoExperimental)
aluno.atualizarPlano(novoPlano: CatalogoPlanos.planoEconomicoAnual)

print("========== TESTE MANUTENÇÃO ==========")
let eq1 = EquipamentoAcademia(nomeMaquina: "Supino", id: "EQ001", tipo: .peito, estado: .funcionando)
let eq2 = EquipamentoAcademia(nomeMaquina: "Leg Press", id: "EQ002", tipo: .perna, estado: .defeituoso)

let r1 = eq1.realizarManutencao(data: "28/04/2026", problema: .estrutura)
print(r1 ? "Operação concluída" : "Operação falhou")

let r2 = eq1.realizarManutencao(data: "28/04/2026", problema: .sistema)
print(r2 ? "Operação concluída" : "Operação falhou")

let r3 = eq2.realizarManutencao(data: "28/04/2026", problema: .cabo)
print(r3 ? "Operação concluída" : "Operação falhou")

print("\nHistórico do equipamento 1:")
print(eq1.historicoMaquina)

let turma = TurmaColetiva(
    nome: "Funcional",
    instrutor: academia.instrutores[0],
    categoria: .funcional,
    descricao: "Treino em grupo",
    capacidadeMin: 2,
    capacidadeMax: 3
)

if turma.inscrever(aluno: aluno) {
    print("Inscrição feita")
}

if turma.inscrever(aluno: aluno) {
    print("Inscrição feita")
}

print("Turma válida? \(turma.turmaValida())")

let personal = TreinoPersonal(
    nome: "Personal",
    instrutor: academia.instrutores[0],
    categoria: .musculacao,
    descricao: "Treino individual",
    aluno: aluno,
    horario: h1
)

print("Treino personal com \(personal.instrutor.nome) para \(personal.aluno.nome)")

let sistema = SistemaAcademia()

sistema.adicionarAluno(aluno)

for instrutor in academia.instrutores {
    sistema.adicionarInstrutor(instrutor)
}

sistema.adicionarEquipamento(eq1)
sistema.adicionarEquipamento(eq2)

sistema.manutencaoEmLote(data: "29/04/2026", problema: .geral)

sistema.agendarPersonal(
    nomeAula: "Personal 1",
    instrutor: academia.instrutores[0],
    aluno: aluno,
    horario: h1
)

print("----- TESTE ATUALIZAR INSTRUTOR -----")
let novoInstrutor = Instrutor(nome: "Carlos Da Silva", email: "carlos@.com", especialidade: .musculacao, horario: h2)
sistema.atualizarInstrutor(email: "carlos@.com", novoInstrutor: novoInstrutor)

print("----- TESTE REMOVER EQUIPAMENTO -----")
sistema.removerEquipamento(id: "EQ001")
sistema.removerEquipamento(id: "EQ999")

print("----- TESTE ALUNOS COM PERSONAL -----")
sistema.alunosComPersonal()

print("----- TESTE RESUMO DO SISTEMA -----")
sistema.resumoSistema()

print("----- TESTE REMOVER AULA -----")
sistema.removerAula(nome: "Personal 1")
sistema.removerAula(nome: "Personal")

print("----- TESTE REMOVER INSTRUTOR -----")
sistema.removerInstrutor(email: "marcos@.com")
sistema.removerInstrutor(email: "marcia@.com")

print("----- TESTE REMOVER ALUNO -----")
sistema.removerAluno(matricula: 123)
sistema.removerAluno(matricula: 321)
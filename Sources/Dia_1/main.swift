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
        let filtrados = instrutores.filter { instrutor in
            instrutor.especialidade == categoria && instrutor.horario == horario
        }
        
        print("Os professores livres das \(horario.hora) de \(categoria.rawValue) são:")
        
        for (index, instrutor) in filtrados.enumerated() {
            print("\(index + 1)- \(instrutor.nome)")
        }
    }
}

let academia = Academia()

let h1 = Horario(hora: "06:00")
let h2 = Horario(hora: "11:00")
let h3 = Horario(hora: "22:00")

academia.adicionarInstrutor(Instrutor(nome: "Carlos", email: "c@.com", especialidade: .musculacao, horario: h1))
academia.adicionarInstrutor(Instrutor(nome: "Bruno", email: "b@.com", especialidade: .musculacao, horario: h2))
academia.adicionarInstrutor(Instrutor(nome: "Rafael", email: "r@.com", especialidade: .musculacao, horario: h3))

academia.adicionarInstrutor(Instrutor(nome: "Ana", email: "a@.com", especialidade: .pilates, horario: h1))
academia.adicionarInstrutor(Instrutor(nome: "Julia", email: "j@.com", especialidade: .pilates, horario: h2))
academia.adicionarInstrutor(Instrutor(nome: "Marcos", email: "m@.com", especialidade: .pilates, horario: h3))

academia.adicionarInstrutor(Instrutor(nome: "Leo", email: "l@.com", especialidade: .yoga, horario: h1))
academia.adicionarInstrutor(Instrutor(nome: "Clara", email: "c@.com", especialidade: .yoga, horario: h2))
academia.adicionarInstrutor(Instrutor(nome: "Paulo", email: "p@.com", especialidade: .yoga, horario: h3))

academia.adicionarInstrutor(Instrutor(nome: "Diego", email: "d@.com", especialidade: .spinning, horario: h1))
academia.adicionarInstrutor(Instrutor(nome: "Fernanda", email: "f@.com", especialidade: .spinning, horario: h2))
academia.adicionarInstrutor(Instrutor(nome: "Gustavo", email: "g@.com", especialidade: .spinning, horario: h3))

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
aluno.atualizarPlano(novoPlano: CatalogoPlanos.planoSucoMensal)
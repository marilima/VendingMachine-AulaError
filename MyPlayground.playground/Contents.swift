import Foundation

class VendingMachineProduct {
    var name: String
    var amount: Int
    var price: Double
    
    init(name: String, amount: Int, price: Double) {
        self.name = name
        self.amount = amount
        self.price = price
    }
}

enum vendingMachineError: Error {
    case produtNotFound
    case productUnavailable
    case insufficientFounds
    case productStuck
    case oCartaoNaoPassou
}

extension vendingMachineError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .produtNotFound:
           return "nao tem isso"
        case.productUnavailable:
            return "nao tem esse produto"
        case .productStuck:
            return "o produto esta preso na maquina"
        case .insufficientFounds:
            return "está faltando dinheiro"
        case .oCartaoNaoPassou:
            return "o seu cartao nao passou"
        }
    }
}
class VendingMachine {
    private var estoque: [VendingMachineProduct]
    private var money: Double
    private var cartao: Bool
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        self.money = 0
        self.cartao = true
    }
    
    func getProduct(named name: String, with money: Double) throws {
        
        self.money += money
        let produtoOptional = estoque.first {
            (produto) -> Bool in
            return produto.name == name }
        
        guard let produto = produtoOptional else {throw vendingMachineError.produtNotFound }
        guard produto.amount > 0 else {
            throw vendingMachineError.productUnavailable }
        guard produto.price <= self.money else {
            throw vendingMachineError.insufficientFounds }
        
        self.money -= produto.price
        produto.amount -= 1
        
        if Int.random(in: 0...1000) < 10 {
            throw vendingMachineError.productStuck
        }
        if cartao == false {
            print("nao passou seu cartao")
        }
    }
    
    func getTroco() -> Double {
        let money = self.money
        self.money = 0.0
        
        return money
    }
}

let vendingMachine =  VendingMachine(products: [
    VendingMachineProduct(name: "Carregador", amount: 5, price: 150.00),
    VendingMachineProduct(name: "chiclete", amount: 2, price: 7.00),
    VendingMachineProduct(name: "trator", amount: 1, price: 75000.00),
    VendingMachineProduct(name: "guarda chuva", amount: 6, price: 34.90)
])
do {
    try vendingMachine.getProduct(named: "trator", with: 75000.00)
    print("ok")
} catch vendingMachineError.productStuck {
    print("ta preso isso ai na maquina tio")
} catch {
    print(error.localizedDescription)
}

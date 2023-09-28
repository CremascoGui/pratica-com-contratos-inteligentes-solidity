// Code based on jocoins ICO https://github.com/hagenderouen/mini-chain/blob/master/hadcoins_ico.sol

// Version of compiler
pragma solidity ^0.5.0;

contract jocoin_ico {

    // Variável que armazena o endereço do investidor
    address private investor;

    // Imprimindo o número máximo de jocoins à venda
    uint public max_jocoins = 1000000;

    // Imprimindo a taxa de conversão de USD para jocoins
    uint public usd_to_jocoins = 1000;

    // Imprimindo o número total de jocoins que foram comprados por investidores
    uint public total_jocoins_bought = 0;

    // Construtor do contrato
    constructor() public  {
        investor = msg.sender;
    }

    // Mapeamento do endereço do investidor para seu patrimônio em jocoins para USD
    mapping(address => uint) equity_jocoins;
    mapping(address => uint) equity_usd;

    // Verificando se o emissor da transação é o investidor
    modifier is_investor() {
        require (msg.sender == investor, "Você não é o investidor!");
        _;
    }

    // Verificando se um investidor pode comprar jocoins
    modifier can_buy_jocoins(uint usd_invested) {
        require (usd_invested * usd_to_jocoins + total_jocoins_bought <= max_jocoins, "Ultrapassou o limite máximo de jocoins.");
        _;
    }

    /*
    // Verifcando se a quantidade de jocoins que um investidor deseja vender é válida
    modifier can_sell_jocoins(uint jocoins_for_sale) {
        require (jocoins_for_sale > 0, "Só é possível vender uma quantidade de jocoins maior que zero.");
        require (jocoins_for_sale <= equity_jocoins[investor], "Não é possível vender mais jocoins do que se tem.");
        _;
    }
    */

    // Verifcando se a quantidade de jocoins que um investidor deseja vender é válida
    modifier can_sell_jocoins(uint jocoins_for_sale) {
        require (jocoins_for_sale > 0, "Só é possível vender uma quantidade de jocoins maior que zero.");
        uint restriction_aux = 9 * equity_jocoins[investor];
        uint restriction = restriction_aux / 10;
        require (jocoins_for_sale <= restriction, "Superou o limite de 90% do saldo.");
        _;
    }

    // Obtendo o patrimônio em jocoins de um investidor
    function equity_in_jocoins() external view is_investor() returns (uint) {
        return equity_jocoins[investor];
    }

    // Obtendo o patrimônio em dólares de um investidor
    function equity_in_usd() external view is_investor() returns (uint) {
        return equity_usd[investor];
    }

    // Comprando jocoins
    function buy_jocoins(uint usd_invested) external
    is_investor() can_buy_jocoins(usd_invested) {
        uint jocoins_bought = usd_invested * usd_to_jocoins;
        equity_jocoins[investor] += jocoins_bought;
        equity_usd[investor] = equity_jocoins[investor] / 1000;
        total_jocoins_bought += jocoins_bought;
    }

    // Vendendo jocoins
    function sell_jocoins(uint jocoins_sold) external
    is_investor() can_sell_jocoins(jocoins_sold) {
        equity_jocoins[investor] -= jocoins_sold;
        equity_usd[investor] = equity_jocoins[investor] / 1000;
        total_jocoins_bought -= jocoins_sold;
    }
}
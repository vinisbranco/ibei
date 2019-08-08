import web3 from '../Web3.js';
import ABI from './ABIPlataforma.json';

//Faz a conexao do web3 com o contrato Parceiro
export default new web3.eth.Contract(ABI, "0xd3a0cf27f45a576732bc503161d83f0374466243");
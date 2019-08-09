import Plataforma from '../Contratos/Plataforma';
import web3 from '../Web3';

export const getProduto = async (id) => {
    var response = await Plataforma.methods.getProduto(id).call().then(
        (result) => {
            return result;
        }
    );
    return response;
}

export const getProdutosLoja = async () => {
    var chaveUsuario;
    await web3.eth.getCoinbase(async (e, account) => {
        if (account !== null) {
            chaveUsuario = account;
        }
    })
    var response = await Plataforma.methods.getProdutosLoja(chaveUsuario).call();
    return response;
}

export const cadastraProduto = async (nome, descricao, preco) => {
    var chaveUsuario;
    await web3.eth.getCoinbase(async (e, account) => {
        if (account !== null) {
            chaveUsuario = account;
        }
    })
    var id = await web3.eth.accounts.create();
    id = id.address;

    await Plataforma.methods.cadastraProduto(id, nome, descricao, preco)
        .send({ from: chaveUsuario })
        .then(
            (result) => {
                return true;
            }
        )
        .catch(
            (erro) => {
                return false;
            }
        );
}
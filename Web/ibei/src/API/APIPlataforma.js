import Plataforma from '../Contratos/Plataforma';
import web3 from '../Web3';

export const getProduto = async (id) => {
    var response = await Plataforma.methods.getProduto(id).call().then(
        (result) => {
            console.log(result);
        }
    );
    return response;
}

export const getProdutosLoja = async (dono) => {
    var response = await Plataforma.methods.getProdutosLoja(dono).call().then(
        (result) => {
            console.log(result);
        }
    );
    return response;
}

export const cadastraProduto = async (id, nome, descricao, preco) => {
    var chaveUsuario;
    web3.eth.getCoinbase(async (e, account) => {
        if (account !== null) {
            chaveUsuario = account;
        }
    })
    await contratoSistema.methods.cadastraProduto(id, nome, descricao, preco)
        .send({ from: chaveUsuario })
        .then(
            (result) => {
                return (result);
            }
        )
        .catch(
            (erro) => {
                return (erro);
            }
        );
}
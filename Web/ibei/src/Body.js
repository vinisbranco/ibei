import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import Grid from '@material-ui/core/Grid';
import Typography from '@material-ui/core/Typography';
import Button from '@material-ui/core/Button';
import Paper from '@material-ui/core/Paper';
import TextField from '@material-ui/core/TextField';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import { getProdutosLoja, cadastraProduto, getProduto } from './API/APIPlataforma';
import CircularProgress from '@material-ui/core/CircularProgress';

const styles = theme => ({
  Title: {
    color: 'gray',
    fontSize: 40,
    padding: '30px 0px 30px 0px'
  },
  caixaRegistra: {
    padding: '30px',
    borderRadius: 6,
    marginLeft: '10px',
    backgroundColor: '#FFFAFA',
  },
  caixaTabela: {
    padding: '30px',
    borderRadius: 6,
    marginRight: '10px',
    backgroundColor: '#FFFAFA',
  },
  subtitulo: {
    color: 'gray',
    fontSize: 40,
  },
  button: {
    width: '100%',
    fontSize: 18,
    borderRadius: 4,
    backgroundColor: "orange"
  },
});

function createData(produto, preco, descricao, status) {
  return { produto, preco, descricao, status };
}




class Body extends React.Component {
  state = {
    produto: '',
    descricao: '',
    preco: '',
    rows: [],
    cadastrando: false
  };

  componentDidMount() {
    this.buscaDados();
  }

  cadastraProduto = async () => {
    this.setState({ cadastrando: true })
    var result = await cadastraProduto(this.state.produto, this.state.descricao, parseInt(this.state.preco.replace(".", "")) * 100);
    await this.buscaDados();
    this.setState({ cadastrando: false, produto: '', descricao: '', preco: '' })
  }

  buscaDados = async () => {
    var result = await getProdutosLoja();
    var rowAux = [];
    for (var i = 0; i < result.length; i++) {
      var resp = await getProduto(result[i]);
      rowAux.push(createData(resp.nome, resp.preco / 100, resp.descricao, resp.estaVendido));
    }

    this.setState({
      rows: rowAux
    })
  }

  handleChange(event) {
    const target = event.target.id;
    const value = event.target.value;
    this.setState({ [target]: value });
  }

  render() {
    const { classes } = this.props;
    const { value } = this.state;
    return (
      (this.state.cadastrando) ?
        <div className={classes.root}>
          <Grid container>
            <Grid item xs={12} md={12} lg={12} xl={12}>
              <Typography align="center" className={classes.Title} >
                ShopChain
              </Typography>
            </Grid>
            <CircularProgress style={{marginLeft: '48%'}}></CircularProgress>
            <Grid item xs={12} md={12} lg={12} xl={12}>
              <Typography align="center" className={classes.Title} >
                Sua requisição está sendo processada!
              </Typography>
            </Grid>
          </Grid>
        </div>
        :
        <div className={classes.root}>
          <Grid container>
            <Grid item xs={12} md={12} lg={12} xl={12}>
              <Typography align="center" className={classes.Title} >
                ShopChain
              </Typography>
            </Grid>
            <Grid className={classes.ladoEsquerdo} item xs={12} md={4} lg={4} xl={4}>
              <Paper className={classes.caixaRegistra} elevation={1}>
                <Typography align="center" className={classes.subtitulo}>
                  Vender produto
              </Typography>

                <Grid item xs={12} md={12} lg={12} xl={12}>
                  <TextField
                    id="produto"
                    label="Produto"
                    placeholder="Carro, Caneca, Camiseta..."
                    fullWidth
                    value={this.state.produto}
                    onChange={this.handleChange.bind(this)}
                    margin="normal"
                    variant="outlined"
                  />
                </Grid>
                <Grid item xs={12} md={12} lg={12} xl={12}>
                  <TextField
                    id="descricao"
                    label="Descrição"
                    placeholder="Cor, Ano, Modelo..."
                    fullWidth
                    value={this.state.descricao}
                    onChange={this.handleChange.bind(this)}
                    margin="normal"
                    variant="outlined"
                  />
                </Grid>
                <Grid item xs={12} md={12} lg={12} xl={12}>
                  <TextField
                    id="preco"
                    label="Preço"
                    placeholder="69.99"
                    fullWidth
                    value={this.state.preco}
                    onChange={this.handleChange.bind(this)}
                    margin="normal"
                    variant="outlined"
                  />
                </Grid>

                <Grid item xs={12} md={12} lg={12} xl={12}>
                  <div align="center">
                    <Button variant="contained" color="primary" className={classes.button} onClick={() => this.cadastraProduto()}>
                      Anunciar
                  </Button>
                  </div>
                </Grid>
              </Paper>
            </Grid>
            <Grid item xs={1} md={1} lg={1} xl={1}>
            </Grid>
            <Grid className={classes.ladoDireito} item xs={12} md={7} lg={7} xl={7}>
              <Paper className={classes.caixaTabela} elevation={1}>
                <Typography align="center" className={classes.subtitulo}>
                  Meus produtos
              </Typography>
                <Table className={classes.table}>
                  <TableHead>
                    <TableRow>
                      <TableCell>Produto</TableCell>
                      <TableCell align="right">Preço</TableCell>
                      <TableCell align="right">Descrição</TableCell>
                      <TableCell align="right">Status</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {this.state.rows.map(row => (
                      <TableRow key={row.name}>
                        <TableCell component="th" scope="row">
                          {row.produto}
                        </TableCell>
                        <TableCell align="right">R$ {row.preco}</TableCell>
                        <TableCell align="right">{row.descricao}</TableCell>
                        <TableCell align="right">{row.status ? "Vendido" : "Disponível"}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </Paper>
            </Grid>
          </Grid>
        </div>
    );
  }
}

Body.propTypes = {
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(Body);
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EstadoListaDePessoas(),
      child: MyApp(),
    ),
  );
}

enum TipoSanguineo {
  aPositivo,
  aNegativo,
  bPositivo,
  bNegativo,
  oPositivo,
  oNegativo,
  abPositivo,
  abNegativo,
}

class Pessoa {
  const Pessoa({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.github,
    required this.tipoSanguineo,
  });

  final String nome;
  final String email;
  final String telefone;
  final String github;
  final TipoSanguineo? tipoSanguineo;
}

class EstadoListaDePessoas with ChangeNotifier {
  final _listaDePessoas = <Pessoa>[];

  List<Pessoa> get pessoas => List.unmodifiable(_listaDePessoas);

  void incluir(Pessoa pessoa) {
    _listaDePessoas.add(pessoa);
    notifyListeners();
  }

  void excluir(Pessoa pessoa) {
    _listaDePessoas.remove(pessoa);
    notifyListeners();
  }

  void alterarDadosPessoa(Pessoa pessoaExistente, Pessoa novosDados) {
    final index = _listaDePessoas.indexOf(pessoaExistente);
    _listaDePessoas[index] = novosDados;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Tipos Sanguíneos'),
          ),
        ),
        body: Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(08.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IncluirPessoa(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                ),
                icon: Icon(Icons.person),
                label: Text(
                  'Incluir Pessoas',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListaPessoas(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                ),
                icon: Icon(Icons.list),
                label: Text(
                  'Listar Pessoas',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IncluirPessoa extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _linkGitHubController = TextEditingController();
  TipoSanguineo? _tipoSanguineo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Cadastro de Pessoas')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório.';
                  }
                  if (value.length < 3) {
                    return 'Nome precisa ter pelo menos 3 letras.';
                  }
                  if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                    return 'Nome precisa começar com letra maiúscula.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "E-mail obrigatório.";
                  }
                  if (!value.contains('@')) {
                    return "E-mail inválido.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                  hintText: '(XX) XXXXX-XXXX',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Telefone obrigatório.";
                  }
                  if (value.length < 11) {
                    return "Número inválido.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _linkGitHubController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "GitHub",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "GitHub obrigatório.";
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<TipoSanguineo>(
                decoration: InputDecoration(labelText: 'Tipo Sanguíneo'),
                value: _tipoSanguineo,
                items: TipoSanguineo.values.map((TipoSanguineo value) {
                  return DropdownMenuItem<TipoSanguineo>(
                    value: value,
                    child: Row(
                      children: [_formatarTipoSanguineo(value)],
                    ),
                  );
                }).toList(),
                onChanged: (TipoSanguineo? value) {
                  _tipoSanguineo = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione um tipo sanguíneo.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Pessoa novaPessoa = Pessoa(
                      nome: _nomeController.text,
                      email: _emailController.text,
                      telefone: _telefoneController.text,
                      github: _linkGitHubController.text,
                      tipoSanguineo: _tipoSanguineo,
                    );
                    Provider.of<EstadoListaDePessoas>(context, listen: false)
                        .incluir(novaPessoa);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.add),
                label: Text('Cadastrar'),
                style: ElevatedButton.styleFrom(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListaPessoas extends StatefulWidget {
  const ListaPessoas({Key? key}) : super(key: key);

  @override
  _ListaPessoasState createState() => _ListaPessoasState();
}

class _ListaPessoasState extends State<ListaPessoas> {
  String _filtro = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Pessoas Cadastradas')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Filtrar itens',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (valor) {
                setState(() {
                  _filtro = valor;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<EstadoListaDePessoas>(
              builder: (context, estadoListaDePessoas, child) {
                final pessoas =
                    Provider.of<EstadoListaDePessoas>(context, listen: false)
                        .pessoas;
                final pessoasFiltradas = _filtrarPessoas(pessoas, _filtro);

                if (pessoas.isEmpty) {
                  return Center(child: Text('Nenhuma pessoa cadastrada.'));
                } else {
                  return ListView.builder(
                    itemCount: pessoasFiltradas.length,
                    itemBuilder: (context, index) {
                      final pessoa = pessoasFiltradas[index];
                      return ListTile(
                        title: Text('Nome: ${pessoa.nome}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('E-mail: ${pessoa.email}'),
                            Text('Telefone: ${pessoa.telefone}'),
                            Text('GitHub: ${pessoa.github}'),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Tipo Sanguíneo: '),
                                  _formatarTipoSanguineo(pessoa.tipoSanguineo),
                                ]),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AlterarPessoa(pessoa: pessoa),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ExcluirPessoa(pessoa: pessoa),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Pessoa> _filtrarPessoas(List<Pessoa> pessoas, String filtro) {
    if (filtro.isEmpty) {
      return pessoas;
    } else {
      return pessoas
          .where((pessoa) =>
              pessoa.nome.toLowerCase().contains(filtro.toLowerCase()) ||
              pessoa.email.toLowerCase().contains(filtro.toLowerCase()) ||
              pessoa.telefone.toLowerCase().contains(filtro.toLowerCase()) ||
              pessoa.github.toLowerCase().contains(filtro.toLowerCase()))
          .toList();
    }
  }
}

class AlterarPessoa extends StatelessWidget {
  final Pessoa pessoa;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AlterarPessoa({Key? key, required this.pessoa}) : super(key: key);

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _linkGitHubController = TextEditingController();
  TipoSanguineo? _tipoSanguineo;

  @override
  Widget build(BuildContext context) {
    _nomeController.text = pessoa.nome;
    _emailController.text = pessoa.email;
    _telefoneController.text = pessoa.telefone;
    _linkGitHubController.text = pessoa.github;
    _tipoSanguineo = pessoa.tipoSanguineo;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Alterar Dados da Pessoa')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório.';
                  }
                  if (value.length < 3) {
                    return 'Nome precisa ter pelo menos 3 letras.';
                  }
                  if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                    return 'Nome precisa começar com letra maiúscula.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "E-mail obrigatório.";
                  }
                  if (!value.contains('@')) {
                    return "E-mail inválido.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                  hintText: '(XX) XXXXX-XXXX',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Telefone obrigatório.";
                  }
                  if (value.length < 11) {
                    return "Número inválido.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _linkGitHubController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "GitHub",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "GitHub obrigatório.";
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<TipoSanguineo>(
                decoration: InputDecoration(labelText: 'Tipo Sanguíneo'),
                value: _tipoSanguineo,
                items: TipoSanguineo.values.map((TipoSanguineo value) {
                  return DropdownMenuItem<TipoSanguineo>(
                    value: value,
                    child: Row(
                      children: [_formatarTipoSanguineo(value)],
                    ),
                  );
                }).toList(),
                onChanged: (TipoSanguineo? value) {
                  _tipoSanguineo = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione um tipo sanguíneo.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Pessoa novosDadosPessoa = Pessoa(
                      nome: _nomeController.text,
                      email: _emailController.text,
                      telefone: _telefoneController.text,
                      github: _linkGitHubController.text,
                      tipoSanguineo: _tipoSanguineo,
                    );
                    Provider.of<EstadoListaDePessoas>(context, listen: false)
                        .alterarDadosPessoa(pessoa, novosDadosPessoa);
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.edit),
                label: Text('Alterar dados'),
                style: ElevatedButton.styleFrom(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExcluirPessoa extends StatelessWidget {
  final Pessoa pessoa;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ExcluirPessoa({Key? key, required this.pessoa}) : super(key: key);

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _linkGitHubController = TextEditingController();
  TipoSanguineo? _tipoSanguineo;

  @override
  Widget build(BuildContext context) {
    _nomeController.text = pessoa.nome;
    _emailController.text = pessoa.email;
    _telefoneController.text = pessoa.telefone;
    _linkGitHubController.text = pessoa.github;
    _tipoSanguineo = pessoa.tipoSanguineo;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Excluír Pessoa')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                readOnly: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              TextFormField(
                controller: _emailController,
                readOnly: true,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                ),
              ),
              TextFormField(
                controller: _telefoneController,
                readOnly: true,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                ),
              ),
              TextFormField(
                controller: _linkGitHubController,
                readOnly: true,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "GitHub",
                ),
              ),
              DropdownButtonFormField<TipoSanguineo>(
                decoration: InputDecoration(labelText: 'Tipo Sanguíneo'),
                value: _tipoSanguineo,
                items: TipoSanguineo.values.map((TipoSanguineo value) {
                  return DropdownMenuItem<TipoSanguineo>(
                    value: value,
                    child: Row(
                      children: [_formatarTipoSanguineo(value)],
                    ),
                  );
                }).toList(),
                onChanged: null,
              ),
              SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: () {
                  Provider.of<EstadoListaDePessoas>(context, listen: false)
                      .excluir(pessoa);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.delete),
                label: Text('Excluir'),
                style: ElevatedButton.styleFrom(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _formatarTipoSanguineo(TipoSanguineo? tipo) {
  Color cor;
  String texto;

  switch (tipo) {
    case TipoSanguineo.aPositivo:
      cor = Colors.blue;
      texto = 'A+';
      break;
    case TipoSanguineo.aNegativo:
      cor = Colors.red;
      texto = 'A-';
      break;
    case TipoSanguineo.bPositivo:
      cor = Colors.purple;
      texto = 'B+';
      break;
    case TipoSanguineo.bNegativo:
      cor = Colors.orange;
      texto = 'B-';
      break;
    case TipoSanguineo.oPositivo:
      cor = Colors.green;
      texto = 'O+';
      break;
    case TipoSanguineo.oNegativo:
      cor = Colors.yellow;
      texto = 'O-';
      break;
    case TipoSanguineo.abPositivo:
      cor = Colors.cyan;
      texto = 'AB+';
      break;
    case TipoSanguineo.abNegativo:
      cor = Colors.white;
      texto = 'AB-';
      break;
    default:
      cor = Colors.black;
      texto = '';
  }

  return Text(
    texto,
    style: TextStyle(color: cor),
  );
}

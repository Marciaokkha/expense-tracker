import 'package:expense_tracker/components/categoria_select.dart';
import 'package:expense_tracker/models/categoria.dart';
import 'package:expense_tracker/models/meta.dart';
import 'package:expense_tracker/pages/categorias_select_page.dart';
import 'package:expense_tracker/repository/metas_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MetaCadastroPage extends StatefulWidget {
  final Meta? metaParaEdicao;

  const MetaCadastroPage({super.key, this.metaParaEdicao});

  @override
  State<MetaCadastroPage> createState() => _MetaCadastroPage();
}

class _MetaCadastroPage extends State<MetaCadastroPage> {
  User? user;
  final metaRepo = MetasRepository();

  final descricaoController = TextEditingController();
  final valorController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');

  final detalhesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Categoria? categoriaSelecionada;

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;

    final meta = widget.metaParaEdicao;

    if (meta != null) {
      categoriaSelecionada = meta.categoria;
 
      descricaoController.text = meta.descricao;
      detalhesController.text = meta.detalhes;

      valorController.text =
          NumberFormat.simpleCurrency(locale: 'pt_BR').format(meta.valor);

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Meta'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescricao(),
                const SizedBox(height: 30),
                _buildCategoriaSelect(),
                const SizedBox(height: 30),
                _buildValor(),
                const SizedBox(height: 30),
                _buildDetalhes(),
                const SizedBox(height: 30),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CategoriaSelect _buildCategoriaSelect() {
    return CategoriaSelect(
      categoria: categoriaSelecionada,
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CategoriesSelectPage(),
          ),
        ) as Categoria?;
        if (result != null) {
          setState(() {
            categoriaSelecionada = result;
          });
        }
      },
    );
  }

  TextFormField _buildDescricao() {
    return TextFormField(
      controller: descricaoController,
      decoration: const InputDecoration(
        hintText: 'Informe a descrição',
        labelText: 'Descrição',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Descrição';
        }
        if (value.length < 5 || value.length > 30) {
          return 'A Descrição deve entre 5 e 30 caracteres';
        }
        return null;
      },
    );
  }

  TextFormField _buildValor() {
    return TextFormField(
      controller: valorController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Informe o valor',
        labelText: 'Valor',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Ionicons.cash_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um Valor';
        }
        final valor = NumberFormat.currency(locale: 'pt_BR')
            .parse(valorController.text.replaceAll('R\$', ''));
        if (valor <= 0) {
          return 'Informe um valor maior que zero';
        }

        return null;
      },
    );
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            // Descricao
            final descricao = descricaoController.text;
            // Valor
            final valor = NumberFormat.currency(locale: 'pt_BR')
                .parse(valorController.text.replaceAll('R\$', ''));
            // Detalhes
            final detalhes = detalhesController.text;

            final userId = user?.id ?? '';

            final meta = Meta(
              id: 0,
              userId: userId,
              descricao: descricao,
              valor: valor.toDouble(),
              categoria: categoriaSelecionada!,
              detalhes: detalhes,
            );

            if (widget.metaParaEdicao == null) {
              await _cadastrarMeta(meta);
            } else {
              meta.id = widget.metaParaEdicao!.id;
              await _alterarMeta(meta);
            }
          }
        },
        child: const Text('Cadastrar'),
      ),
    );
  }

  TextFormField _buildDetalhes() {
    return TextFormField(
      controller: detalhesController,
      decoration: const InputDecoration(
        hintText: 'Detalhes da transação',
        labelText: 'Detalhes',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: 2,
    );
  }

  Future<void> _cadastrarMeta(Meta meta) async {
    final scaffold = ScaffoldMessenger.of(context);
    await metaRepo.cadastrarMetas(meta).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'Meta cadastrada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'Erro ao cadastrar meta',
        ),
      ));
      Navigator.of(context).pop(false);
    });
  }

  Future<void> _alterarMeta(Meta meta) async {
    final scaffold = ScaffoldMessenger.of(context);
    await metaRepo.alterarMeta(meta).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'Meta alterada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'Erro ao alterar meta',
        ),
      ));
      Navigator.of(context).pop(false);
    });
  }
}

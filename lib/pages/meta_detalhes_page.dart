import 'package:expense_tracker/components/meta_item.dart';
import 'package:expense_tracker/models/meta_detalhes_argumentos.dart';
import 'package:flutter/material.dart';

class MetaDetalhesPage extends StatefulWidget {
  const MetaDetalhesPage({super.key});

  @override
  State<MetaDetalhesPage> createState() => _MetaDetalhesPage();
}

class _MetaDetalhesPage extends State<MetaDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    final argumentos = ModalRoute.of(context)!.settings.arguments as MetaDetalhesArgumentos;
    final meta = argumentos.meta;
    final previsao = (meta.valor / argumentos.valorPoupado).ceil();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text(meta.descricao),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MetaItem(meta: meta),
            ListTile(
              title: const Text('Observação'),
              subtitle:
                  Text(meta.detalhes.isEmpty ? '-' : meta.detalhes),
            ),
            ListTile(
              title: const Text('Previsão'),
              subtitle:
                  Text('Seguindo o ritmo atual, você chegará lá em $previsao ${previsao == 1 ? "mês." : "meses."}'),
            ),
          ],
        ),
      ),
    );
  }
}

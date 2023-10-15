import 'package:expense_tracker/models/meta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MetaItem extends StatelessWidget {
  final Meta meta;
  final void Function()? onTap;
  const MetaItem({Key? key, required this.meta, this.onTap}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: meta.categoria.cor,
        child: Icon(
          meta.categoria.icone,
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(meta.descricao),
      subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR').format(meta.valor)),
      onTap: onTap
    );
  }
}

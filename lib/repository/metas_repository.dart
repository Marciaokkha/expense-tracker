import 'package:expense_tracker/models/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MetasRepository {
  Future<List<Meta>> listarMetas(
      {required String userId}) async {
    final supabase = Supabase.instance.client;

    var query = supabase.from('metas').select<List<Map<String, dynamic>>>('''
            *,
            categorias (
              *
            )
            ''').eq('user_id', userId);

    var data = await query;

    final list = data.map((map) {
      return Meta.fromMap(map);
    }).toList();

    return list;
  }

  Future cadastrarMetas(Meta meta) async {
    final supabase = Supabase.instance.client;

    await supabase.from('metas').insert({
      'descricao': meta.descricao,
      'user_id': meta.userId,
      'valor': meta.valor,
      'detalhes': meta.detalhes,
      'categoria_id': meta.categoria.id,
    });
  }

  Future alterarMeta(Meta meta) async {
    final supabase = Supabase.instance.client;

    await supabase.from('metas').update({
      'descricao': meta.descricao,
      'valor': meta.valor,
      'detalhes': meta.detalhes,
      'categoria_id': meta.categoria.id,
    }).match({'id': meta.id});
  }

  Future excluirMeta(int id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('metas').delete().match({'id': id});
  }
}

import 'package:expense_tracker/models/categoria.dart';

class Meta {
  int id;
  String userId;
  String descricao;
  double valor;
  String detalhes = '';
  Categoria categoria;

  Meta({
    required this.id,
    required this.userId,
    required this.descricao,
    required this.valor,
    required this.categoria,
    this.detalhes = '',
  });

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      id: map['id'],
      userId: map['user_id'],
      descricao: map['descricao'],
      valor: map['valor'],
      detalhes: map['detalhes'] ?? '',
      categoria: Categoria.fromMap(map['categorias']),
    );
  }
}

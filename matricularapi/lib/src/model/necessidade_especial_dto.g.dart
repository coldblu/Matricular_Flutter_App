// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'necessidade_especial_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NecessidadeEspecialDTO extends NecessidadeEspecialDTO {
  @override
  final int? id;
  @override
  final int? matriculaId;
  @override
  final String? titulo;

  factory _$NecessidadeEspecialDTO(
          [void Function(NecessidadeEspecialDTOBuilder)? updates]) =>
      (new NecessidadeEspecialDTOBuilder()..update(updates))._build();

  _$NecessidadeEspecialDTO._({this.id, this.matriculaId, this.titulo})
      : super._();

  @override
  NecessidadeEspecialDTO rebuild(
          void Function(NecessidadeEspecialDTOBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NecessidadeEspecialDTOBuilder toBuilder() =>
      new NecessidadeEspecialDTOBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NecessidadeEspecialDTO &&
        id == other.id &&
        matriculaId == other.matriculaId &&
        titulo == other.titulo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, matriculaId.hashCode);
    _$hash = $jc(_$hash, titulo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NecessidadeEspecialDTO')
          ..add('id', id)
          ..add('matriculaId', matriculaId)
          ..add('titulo', titulo))
        .toString();
  }
}

class NecessidadeEspecialDTOBuilder
    implements Builder<NecessidadeEspecialDTO, NecessidadeEspecialDTOBuilder> {
  _$NecessidadeEspecialDTO? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _matriculaId;
  int? get matriculaId => _$this._matriculaId;
  set matriculaId(int? matriculaId) => _$this._matriculaId = matriculaId;

  String? _titulo;
  String? get titulo => _$this._titulo;
  set titulo(String? titulo) => _$this._titulo = titulo;

  NecessidadeEspecialDTOBuilder() {
    NecessidadeEspecialDTO._defaults(this);
  }

  NecessidadeEspecialDTOBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _matriculaId = $v.matriculaId;
      _titulo = $v.titulo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NecessidadeEspecialDTO other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NecessidadeEspecialDTO;
  }

  @override
  void update(void Function(NecessidadeEspecialDTOBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NecessidadeEspecialDTO build() => _build();

  _$NecessidadeEspecialDTO _build() {
    final _$result = _$v ??
        new _$NecessidadeEspecialDTO._(
            id: id, matriculaId: matriculaId, titulo: titulo);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

import 'dart:convert';

class Note {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // Constructeur pour créer une nouvelle note
  Note.create({
    required this.title,
    required this.content,
  }) : 
    id = DateTime.now().millisecondsSinceEpoch.toString(),
    createdAt = DateTime.now(),
    updatedAt = DateTime.now();

  // Conversion vers Map pour la sérialisation
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Création depuis Map pour la désérialisation
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Conversion vers JSON
  String toJson() => json.encode(toMap());

  // Création depuis JSON
  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  // Méthode pour mettre à jour la note
  Note copyWith({
    String? title,
    String? content,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Getter pour obtenir un aperçu du contenu
  String get preview {
    if (content.length <= 100) {
      return content;
    }
    return '${content.substring(0, 100)}...';
  }

  // Getter pour obtenir le titre formaté
  String get displayTitle {
    if (title.trim().isEmpty) {
      return 'Note sans titre';
    }
    return title;
  }

  // Getter pour obtenir la date formatée
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} heure${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'À l\'instant';
    }
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: ${content.length} chars, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Note && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

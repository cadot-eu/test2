import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteService extends ChangeNotifier {
  final SharedPreferences _prefs;
  List<Note> _notes = [];
  static const String _notesKey = 'notes';

  NoteService(this._prefs);

  // Getter pour obtenir la liste des notes (triées par date de création décroissante)
  List<Note> get notes => List.unmodifiable(_notes.reversed);

  // Charger les notes depuis le stockage local
  Future<void> loadNotes() async {
    try {
      final notesJson = _prefs.getStringList(_notesKey) ?? [];
      _notes = notesJson
          .map((json) => Note.fromJson(json))
          .toList();
      
      // Trier par date de création (plus récentes en premier)
      _notes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      
      notifyListeners();
    } catch (e) {
      print('Erreur lors du chargement des notes: $e');
      _notes = [];
    }
  }

  // Sauvegarder les notes dans le stockage local
  Future<void> _saveNotes() async {
    try {
      final notesJson = _notes.map((note) => note.toJson()).toList();
      await _prefs.setStringList(_notesKey, notesJson);
    } catch (e) {
      print('Erreur lors de la sauvegarde des notes: $e');
    }
  }

  // Ajouter une nouvelle note
  Future<Note> addNote({
    required String title,
    required String content,
  }) async {
    final note = Note.create(
      title: title.trim(),
      content: content,
    );
    
    _notes.add(note);
    await _saveNotes();
    notifyListeners();
    
    return note;
  }

  // Mettre à jour une note existante
  Future<void> updateNote(String noteId, {
    String? title,
    String? content,
  }) async {
    final noteIndex = _notes.indexWhere((note) => note.id == noteId);
    
    if (noteIndex != -1) {
      _notes[noteIndex] = _notes[noteIndex].copyWith(
        title: title?.trim(),
        content: content,
      );
      
      await _saveNotes();
      notifyListeners();
    }
  }

  // Supprimer une note
  Future<void> deleteNote(String noteId) async {
    _notes.removeWhere((note) => note.id == noteId);
    await _saveNotes();
    notifyListeners();
  }

  // Obtenir une note par son ID
  Note? getNoteById(String noteId) {
    try {
      return _notes.firstWhere((note) => note.id == noteId);
    } catch (e) {
      return null;
    }
  }

  // Rechercher des notes par titre ou contenu
  List<Note> searchNotes(String query) {
    if (query.trim().isEmpty) {
      return notes;
    }
    
    final lowercaseQuery = query.toLowerCase();
    return notes.where((note) {
      return note.title.toLowerCase().contains(lowercaseQuery) ||
             note.content.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Obtenir le nombre total de notes
  int get notesCount => _notes.length;

  // Vérifier si une note existe
  bool noteExists(String noteId) {
    return _notes.any((note) => note.id == noteId);
  }

  // Dupliquer une note
  Future<Note> duplicateNote(String noteId) async {
    final originalNote = getNoteById(noteId);
    if (originalNote == null) {
      throw Exception('Note non trouvée');
    }
    
    final duplicatedNote = Note.create(
      title: '${originalNote.title} (Copie)',
      content: originalNote.content,
    );
    
    _notes.add(duplicatedNote);
    await _saveNotes();
    notifyListeners();
    
    return duplicatedNote;
  }

  // Exporter toutes les notes en JSON
  String exportNotesToJson() {
    final export = {
      'notes': _notes.map((note) => note.toMap()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0.0',
    };
    
    return json.encode(export);
  }

  // Importer des notes depuis JSON
  Future<int> importNotesFromJson(String jsonString) async {
    try {
      final data = json.decode(jsonString) as Map<String, dynamic>;
      final notesList = data['notes'] as List<dynamic>;
      
      int importedCount = 0;
      
      for (final noteData in notesList) {
        final note = Note.fromMap(noteData as Map<String, dynamic>);
        
        // Éviter les doublons en vérifiant l'ID
        if (!noteExists(note.id)) {
          _notes.add(note);
          importedCount++;
        }
      }
      
      if (importedCount > 0) {
        // Retrier les notes après l'import
        _notes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        await _saveNotes();
        notifyListeners();
      }
      
      return importedCount;
    } catch (e) {
      throw Exception('Erreur lors de l\'import: $e');
    }
  }

  // Effacer toutes les notes (avec confirmation)
  Future<void> clearAllNotes() async {
    _notes.clear();
    await _saveNotes();
    notifyListeners();
  }

  // Obtenir des statistiques sur les notes
  Map<String, dynamic> getStatistics() {
    final totalNotes = _notes.length;
    final totalCharacters = _notes.fold<int>(
      0,
      (sum, note) => sum + note.content.length,
    );
    
    final averageLength = totalNotes > 0 ? totalCharacters / totalNotes : 0;
    
    return {
      'totalNotes': totalNotes,
      'totalCharacters': totalCharacters,
      'averageLength': averageLength.round(),
      'oldestNote': _notes.isEmpty 
          ? null 
          : _notes.reduce((a, b) => a.createdAt.isBefore(b.createdAt) ? a : b),
      'newestNote': _notes.isEmpty 
          ? null 
          : _notes.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b),
    };
  }
}

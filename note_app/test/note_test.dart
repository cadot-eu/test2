import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/models/note.dart';

void main() {
  group('Note Model Tests', () {
    test('Should create note with all properties', () {
      final note = Note.create(
        title: 'Test Note',
        content: 'This is a test note content',
      );

      expect(note.title, 'Test Note');
      expect(note.content, 'This is a test note content');
      expect(note.id, isNotEmpty);
      expect(note.createdAt, isNotNull);
      expect(note.updatedAt, isNotNull);
    });

    test('Should serialize and deserialize note correctly', () {
      final originalNote = Note.create(
        title: 'Serialization Test',
        content: 'Testing JSON serialization',
      );

      // Serialize to JSON
      final json = originalNote.toJson();
      
      // Deserialize from JSON
      final deserializedNote = Note.fromJson(json);

      expect(deserializedNote.id, originalNote.id);
      expect(deserializedNote.title, originalNote.title);
      expect(deserializedNote.content, originalNote.content);
      expect(deserializedNote.createdAt, originalNote.createdAt);
      expect(deserializedNote.updatedAt, originalNote.updatedAt);
    });

    test('Should return correct display title', () {
      final noteWithTitle = Note.create(
        title: 'My Note',
        content: 'Content',
      );
      expect(noteWithTitle.displayTitle, 'My Note');

      final noteWithoutTitle = Note.create(
        title: '',
        content: 'Content',
      );
      expect(noteWithoutTitle.displayTitle, 'Note sans titre');
    });

    test('Should return correct preview', () {
      final shortNote = Note.create(
        title: 'Short',
        content: 'Short content',
      );
      expect(shortNote.preview, 'Short content');

      final longNote = Note.create(
        title: 'Long',
        content: 'This is a very long content that should be truncated because it exceeds the maximum preview length of 100 characters for sure',
      );
      expect(longNote.preview.length, lessThanOrEqualTo(103)); // 100 + "..."
      expect(longNote.preview.endsWith('...'), true);
    });

    test('Should update note correctly with copyWith', () {
      final originalNote = Note.create(
        title: 'Original Title',
        content: 'Original Content',
      );

      final updatedNote = originalNote.copyWith(
        title: 'Updated Title',
        content: 'Updated Content',
      );

      expect(updatedNote.id, originalNote.id);
      expect(updatedNote.title, 'Updated Title');
      expect(updatedNote.content, 'Updated Content');
      expect(updatedNote.createdAt, originalNote.createdAt);
      expect(updatedNote.updatedAt.isAfter(originalNote.updatedAt), true);
    });

    test('Should handle equality correctly', () {
      final note1 = Note.create(title: 'Test', content: 'Content');
      final note2 = Note.create(title: 'Test', content: 'Content');
      final note3 = Note(
        id: note1.id,
        title: 'Different Title',
        content: 'Different Content',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(note1 == note2, false); // Different IDs
      expect(note1 == note3, true);  // Same ID
      expect(note1.hashCode, note3.hashCode); // Same hash code
    });

    test('Should format date correctly', () {
      final note = Note.create(title: 'Test', content: 'Content');
      expect(note.formattedDate, isNotEmpty);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note;

  const NoteEditorPage({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage>
    with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();
  
  late TabController _tabController;
  bool _isEditing = false;
  bool _hasUnsavedChanges = false;
  
  // Variables pour la gestion de l'état
  String _initialTitle = '';
  String _initialContent = '';

  @override
  void initState() {
    super.initState();
    _isEditing = widget.note != null;
    _tabController = TabController(length: 2, vsync: this);
    
    if (_isEditing) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _initialTitle = widget.note!.title;
      _initialContent = widget.note!.content;
    } else {
      // Focus automatique sur le titre pour une nouvelle note
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleFocusNode.requestFocus();
      });
    }
    
    // Écouter les changements pour détecter les modifications non sauvegardées
    _titleController.addListener(_checkForChanges);
    _contentController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final hasChanges = _titleController.text != _initialTitle ||
        _contentController.text != _initialContent;
    
    if (hasChanges != _hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = hasChanges;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvoked: (bool didPop) async {
        if (!didPop && _hasUnsavedChanges) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildTitleField(),
            _buildTabBar(),
            Expanded(
              child: _buildTabBarView(),
            ),
          ],
        ),
        floatingActionButton: _buildSaveButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_isEditing ? 'Modifier la note' : 'Nouvelle note'),
      actions: [
        if (_isEditing)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteNote,
            tooltip: 'Supprimer',
          ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: _showMarkdownHelp,
          tooltip: 'Aide Markdown',
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _titleController,
        focusNode: _titleFocusNode,
        decoration: const InputDecoration(
          hintText: 'Titre de la note...',
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textInputAction: TextInputAction.next,
        onSubmitted: (_) {
          _contentFocusNode.requestFocus();
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: const [
          Tab(
            icon: Icon(Icons.edit),
            text: 'Édition',
          ),
          Tab(
            icon: Icon(Icons.preview),
            text: 'Aperçu',
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildEditorTab(),
        _buildPreviewTab(),
      ],
    );
  }

  Widget _buildEditorTab() {
    return Container(
      color: Colors.grey[50],
      child: TextField(
        controller: _contentController,
        focusNode: _contentFocusNode,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
          hintText: 'Écrivez votre note en Markdown ici...\n\n**Gras** *Italique*\n# Titre\n- Liste\n[Lien](url)',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          fontFamily: 'monospace',
        ),
        textInputAction: TextInputAction.newline,
      ),
    );
  }

  Widget _buildPreviewTab() {
    return Container(
      color: Colors.white,
      child: _contentController.text.trim().isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.preview,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'L\'aperçu apparaîtra ici',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Commencez à écrire dans l\'onglet Édition',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : Markdown(
              data: _contentController.text,
              padding: const EdgeInsets.all(16),
              styleSheet: MarkdownStyleSheet(
                h1: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
                h2: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
                h3: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
                p: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
                code: TextStyle(
                  backgroundColor: Colors.grey[200],
                  fontFamily: 'monospace',
                ),
                codeblockDecoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
              ),
            ),
    );
  }

  Widget _buildSaveButton() {
    return FloatingActionButton.extended(
      onPressed: _saveNote,
      icon: const Icon(Icons.save),
      label: Text(_isEditing ? 'Mettre à jour' : 'Enregistrer'),
      backgroundColor: _hasUnsavedChanges
          ? Theme.of(context).primaryColor
          : Colors.grey,
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) {
      return true;
    }

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifications non sauvegardées'),
        content: const Text(
          'Vous avez des modifications non sauvegardées. Voulez-vous les enregistrer avant de quitter ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ignorer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
              _saveNote();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  void _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text;

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir au moins un titre ou du contenu'),
        ),
      );
      return;
    }

    try {
      if (_isEditing) {
        await context.read<NoteService>().updateNote(
          widget.note!.id,
          title: title,
          content: content,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note mise à jour avec succès')),
        );
      } else {
        await context.read<NoteService>().addNote(
          title: title.isEmpty ? 'Note sans titre' : title,
          content: content,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note créée avec succès')),
        );
      }

      _hasUnsavedChanges = false;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sauvegarde: $e')),
      );
    }
  }

  void _deleteNote() {
    if (!_isEditing) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la note'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer cette note ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<NoteService>().deleteNote(widget.note!.id);
              Navigator.pop(context); // Fermer le dialog
              Navigator.pop(context); // Retourner à la page précédente
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note supprimée')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showMarkdownHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aide Markdown'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem('**Gras**', 'Texte en gras'),
              _buildHelpItem('*Italique*', 'Texte en italique'),
              _buildHelpItem('# Titre 1', 'Titre principal'),
              _buildHelpItem('## Titre 2', 'Sous-titre'),
              _buildHelpItem('### Titre 3', 'Sous-sous-titre'),
              _buildHelpItem('- Item', 'Liste à puces'),
              _buildHelpItem('1. Item', 'Liste numérotée'),
              _buildHelpItem('[Lien](url)', 'Lien hypertexte'),
              _buildHelpItem('`code`', 'Code en ligne'),
              _buildHelpItem('```\ncode\n```', 'Bloc de code'),
              _buildHelpItem('> Citation', 'Citation'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String syntax, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              syntax,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/application/auth/auth_bloc.dart';
import 'package:wall/application/post/post_bloc.dart';
import 'package:wall/presentation/pages/auth_page.dart';
import 'package:wall/presentation/widgets/post_card.dart';
import '../../data/models/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WallPage extends StatelessWidget {
  const WallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wall'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOut());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AuthPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: state.posts[index]);
              },
            );
          } else if (state is PostError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No posts yet'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddPostDialog(context),
      ),
    );
  }

  void _showAddPostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddPostDialog(),
    );
  }
}

class AddPostDialog extends StatefulWidget {
  const AddPostDialog({super.key});

  @override
  _AddPostDialogState createState() => _AddPostDialogState();
}

class _AddPostDialogState extends State<AddPostDialog> {
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a new post'),
      content: TextField(
        controller: _contentController,
        decoration: const InputDecoration(hintText: 'What\'s on your mind?'),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('Post'),
          onPressed: () {
            if (_contentController.text.isNotEmpty) {
              final user = FirebaseAuth.instance.currentUser!;
              final newPost = PostModel(
                id: '', // Firestore will generate this
                userId: user.uid,
                userName: user.displayName ?? 'Anonymous',
                content: _contentController.text,
                timestamp: DateTime.now(),
              );
              context.read<PostBloc>().add(AddPost(newPost));
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}

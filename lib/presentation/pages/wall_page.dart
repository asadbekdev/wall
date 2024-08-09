import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wall/application/auth/auth_bloc.dart';
import 'package:wall/application/post/post_bloc.dart';
import 'package:wall/data/models/post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall/presentation/pages/auth_page.dart';
import 'package:wall/presentation/widgets/post_card.dart';

class WallPage extends StatefulWidget {
  @override
  _WallPageState createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  final TextEditingController _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AuthPage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100], // Light grey background
        appBar: AppBar(
          title: const Text('Wall', style: TextStyle(fontSize: 24)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Implement logout functionality
                FirebaseAuth.instance.signOut();
                // Navigate to login page
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _buildPostInput(),
            const Divider(color: Colors.black, height: 1),
            Expanded(
              child: BlocBuilder<PostBloc, PostState>(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _postController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Write something here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _submitPost,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Add to the wall',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitPost() {
    if (_postController.text.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final newPost = PostModel(
          id: '',
          userId: user.uid,
          userName: user.displayName ?? 'Anonymous',
          userPhotoUrl: user.photoURL,
          content: _postController.text,
          timestamp: DateTime.now(),
        );
        context.read<PostBloc>().add(AddPost(newPost));
        _postController.clear();
      }
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }
}

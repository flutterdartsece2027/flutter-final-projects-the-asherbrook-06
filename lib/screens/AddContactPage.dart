// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

// components
import 'package:buzz/components/ContactCard.dart';

// model
import 'package:buzz/models/User.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<UserModel> _searchResults = [];
  bool _isLoading = false;

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _searchUsers(query);
    } else {
      setState(() => _searchResults.clear());
    }
  }

  Future<void> _searchUsers(String email) async {
    setState(() => _isLoading = true);
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: email.toLowerCase())
        .where('email', isLessThan: '${email.toLowerCase()}z')
        .get();

    final results = snapshot.docs.where((doc) => doc.id != currentUser.uid).map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['uid'] = doc.id;
      return UserModel.fromMap(data);
    }).toList();

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  Future<void> _addContact(UserModel contact) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final userDoc = _firestore.collection('users').doc(currentUser.uid);
    final contactRef = userDoc.collection('contacts').doc(contact.uid);

    final snapshot = await contactRef.get();
    if (!snapshot.exists) {
      await contactRef.set(contact.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          content: Text(
            '${contact.name} added to your contacts!',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          content: Text(
            '${contact.name} is already in your contacts.',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = (View.of(context).platformDispatcher.platformBrightness == Brightness.light)
        ? "light"
        : "dark";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        leading: IconButton(
          icon: const Icon(HugeIcons.strokeRoundedArrowLeft01),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Add Contact"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (_searchController.text.trim().isNotEmpty) {
            await _searchUsers(_searchController.text.trim());
          }
        },
        color: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        elevation: 0,
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: SliverSearchBar(controller: _searchController),
            ),
            _isLoading
                ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                : _searchResults.isEmpty
                ? _searchController.text.isNotEmpty
                      ? SliverFillRemaining(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(child: SizedBox()),
                                SvgPicture.asset("assets/$theme/add_contact.svg", width: 220),
                                const SizedBox(height: 24),
                                Text(
                                  "No contacts found",
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Try a different name or email",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                          ),
                        )
                      : SliverFillRemaining(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(child: SizedBox()),
                                SvgPicture.asset("assets/$theme/add_contact.svg", width: 220),
                                const SizedBox(height: 24),
                                Text(
                                  "Add a Contact",
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Search them with email",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                          ),
                        )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final contact = _searchResults[index];
                      return ContactCard(
                        contactModel: contact,
                        trailing: IconButton(
                          icon: const Icon(HugeIcons.strokeRoundedUserAdd02),
                          onPressed: () => _addContact(contact),
                        ),
                      );
                    }, childCount: _searchResults.length),
                  ),
          ],
        ),
      ),
    );
  }
}

class SliverSearchBar extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;

  SliverSearchBar({required this.controller});

  @override
  double get minExtent => 64;
  @override
  double get maxExtent => 64;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          hintText: 'Search by email...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverSearchBar oldDelegate) => false;
}

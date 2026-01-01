import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/profile_strings.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/widgets/invite_friend_item_widget.dart';

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({super.key});

  static const String path = '/profile/invite-friends';
  static const String name = 'invite-friends';

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  final List<Contact> _contacts = [
    Contact(
      id: '1',
      name: 'Tynisha Obey',
      phone: '+1-300-555-0135',
      imageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      isInvited: false,
    ),
    Contact(
      id: '2',
      name: 'Florencio Dorrance',
      phone: '+1-202-555-0136',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      isInvited: true,
    ),
    Contact(
      id: '3',
      name: 'Chantal Shelburne',
      phone: '+1-300-555-0119',
      imageUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      isInvited: false,
    ),
    Contact(
      id: '4',
      name: 'Maryland Winkles',
      phone: '+1-300-555-0161',
      imageUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      isInvited: true,
    ),
    Contact(
      id: '5',
      name: 'Rodolfo Goode',
      phone: '+1-300-555-0136',
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
      isInvited: true,
    ),
    Contact(
      id: '6',
      name: 'Benny Spanbauer',
      phone: '+1-202-555-0167',
      imageUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
      isInvited: false,
    ),
    Contact(
      id: '7',
      name: 'Tyra Dhillon',
      phone: '+1-202-555-0119',
      imageUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
      isInvited: false,
    ),
    Contact(
      id: '8',
      name: 'Jamel Eusebio',
      phone: '+1-300-555-0171',
      imageUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
      isInvited: true,
    ),
    Contact(
      id: '9',
      name: 'Pedro Huard',
      phone: '+1-202-555-0171',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      isInvited: false,
    ),
    Contact(
      id: '10',
      name: 'Clinton Mcclure',
      phone: '+1-202-555-0171',
      imageUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
      isInvited: false,
    ),
  ];

  void _handleInvite(Contact contact) {
    setState(() {
      final index = _contacts.indexWhere((c) => c.id == contact.id);
      if (index != -1) {
        _contacts[index] = Contact(
          id: contact.id,
          name: contact.name,
          phone: contact.phone,
          imageUrl: contact.imageUrl,
          isInvited: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AppIcons.arrowBack(color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          ProfileStrings.inviteFriends,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InviteFriendItemWidget(
              contact: _contacts[index],
              onInvite: () => _handleInvite(_contacts[index]),
            ),
          );
        },
      ),
    );
  }
}

class Contact {
  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.imageUrl,
    required this.isInvited,
  });

  final String id;
  final String name;
  final String phone;
  final String imageUrl;
  final bool isInvited;
}

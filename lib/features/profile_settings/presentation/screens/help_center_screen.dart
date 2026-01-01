import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/profile_strings.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/customer_service_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/widgets/faq_item_widget.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/widgets/help_center_tab_bar.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  static const String path = '/profile/help-center';
  static const String name = 'help-center';

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = ProfileStrings.general;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    ProfileStrings.general,
    ProfileStrings.account,
    ProfileStrings.service,
    ProfileStrings.paymentLower,
  ];

  final List<FAQItem> _faqItems = [
    FAQItem(
      question: ProfileStrings.whatIsEvira,
      answer:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      isExpanded: true,
    ),
    FAQItem(
      question: ProfileStrings.howToUseEvira,
      answer: '',
      isExpanded: false,
    ),
    FAQItem(
      question: ProfileStrings.howToCancelOrder,
      answer: '',
      isExpanded: false,
    ),
    FAQItem(
      question: ProfileStrings.isEviraFree,
      answer: '',
      isExpanded: false,
    ),
    FAQItem(
      question: ProfileStrings.howToAddPromo,
      answer: '',
      isExpanded: false,
    ),
    FAQItem(
      question: ProfileStrings.whyPaymentNotWorking,
      answer: '',
      isExpanded: false,
    ),
    FAQItem(
      question: ProfileStrings.whyShippingPricesDifferent,
      answer: '',
      isExpanded: false,
    ),
    FAQItem(
      question: ProfileStrings.whyCantAddPayment,
      answer: '',
      isExpanded: false,
    ),
    FAQItem(
      question: ProfileStrings.whyNoReceipt,
      answer: '',
      isExpanded: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
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
          ProfileStrings.helpCenter,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: AppIcons.moreVertical(
              color: colorScheme.onSurface,
            ),
            onPressed: () {
              // TODO: Implement more options
            },
          ),
        ],
        bottom: HelpCenterTabBar(controller: _tabController),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFAQTab(),
          _buildContactTab(),
        ],
      ),
    );
  }

  Widget _buildFAQTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Category Filters
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(category),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: colorScheme.surface,
                    selectedColor: colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Search Bar
          SearchBar(
            controller: _searchController,
            hintText: ProfileStrings.searchPlaceholder,
            leading: Padding(
              padding: const EdgeInsets.all(12),
              child: AppIcons.search(
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            trailing: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: AppIcons.filter(
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ],
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // FAQ List
          ..._faqItems.map(
            (faq) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FAQItemWidget(
                faq: faq,
                onTap: () {
                  setState(() {
                    faq.isExpanded = !faq.isExpanded;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final contactMethods = <ContactMethod>[
      ContactMethod(
        name: ProfileStrings.customerServiceContact,
        icon: Icons.headphones,
        onTap: () {
          context.push(CustomerServiceScreen.path);
        },
      ),
      ContactMethod(
        name: ProfileStrings.whatsapp,
        icon: Icons.chat,
        onTap: () {
          // TODO: Open WhatsApp
        },
      ),
      ContactMethod(
        name: ProfileStrings.website,
        icon: Icons.language,
        onTap: () {
          // TODO: Open website
        },
      ),
      ContactMethod(
        name: ProfileStrings.facebook,
        icon: Icons.facebook,
        onTap: () {
          // TODO: Open Facebook
        },
      ),
      ContactMethod(
        name: ProfileStrings.twitter,
        icon: Icons.alternate_email,
        onTap: () {
          // TODO: Open Twitter
        },
      ),
      ContactMethod(
        name: ProfileStrings.instagram,
        icon: Icons.camera_alt,
        onTap: () {
          // TODO: Open Instagram
        },
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: contactMethods.length,
      itemBuilder: (context, index) {
        final contact = contactMethods[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                contact.icon,
                color: colorScheme.onSurface,
              ),
              title: Text(
                contact.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: contact.onTap,
            ),
          ),
        );
      },
    );
  }
}

class FAQItem {
  FAQItem({
    required this.question,
    required this.answer,
    required this.isExpanded,
  });

  final String question;
  final String answer;
  bool isExpanded;
}

class ContactMethod {
  ContactMethod({
    required this.name,
    required this.icon,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final VoidCallback onTap;
}

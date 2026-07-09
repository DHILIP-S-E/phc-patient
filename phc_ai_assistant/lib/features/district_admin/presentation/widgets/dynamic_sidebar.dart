import 'package:flutter/material.dart';

class DynamicSidebar extends StatelessWidget {
  final String role; // e.g., 'DISTRICT_ADMIN'

  const DynamicSidebar({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // Generate menu dynamically based on role permissions
    // State Admin sees everything. District Admin sees restricted view.
    // Medical Officer sees Clinical Desk.

    List<Widget> menuItems = [];

    menuItems.add(
      const DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue),
        child: Text('NHM Health Platform', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );

    if (role == 'STATE_ADMIN' || role == 'DISTRICT_ADMIN') {
      menuItems.add(
        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text('Executive Dashboard'),
          onTap: () {}, // Navigate
        ),
      );
      menuItems.add(
        ListTile(
          leading: const Icon(Icons.local_shipping),
          title: const Text('Supply Chain (Indents)'),
          onTap: () {},
        ),
      );
    }

    if (role == 'DISTRICT_ADMIN') {
      menuItems.add(
        ListTile(
          leading: const Icon(Icons.business),
          title: const Text('My District Facilities'),
          onTap: () {},
        ),
      );
    }

    // Notice that 'Clinical Desk' is EXCLUDED for Administrators
    if (role == 'MEDICAL_OFFICER') {
      menuItems.add(
        ListTile(
          leading: const Icon(Icons.medical_services),
          title: const Text('Clinical Desk (OPD)'),
          onTap: () {},
        ),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: menuItems,
      ),
    );
  }
}

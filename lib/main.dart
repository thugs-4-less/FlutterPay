import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter_pay/dashboard_screen.dart';
import 'package:flutter_pay/send_screen.dart';
import 'package:flutter_pay/card_screen.dart';
import 'package:flutter_pay/history_screen.dart';
import 'package:flutter_pay/profile_screen.dart';
import 'package:flutter_pay/transaction_model.dart';
import 'package:flutter_pay/theme_provider.dart';

/// The main entry point of the application.
/// Wraps the app in a [ChangeNotifierProvider] to manage theme state.
void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

/// The primary brand color for the application.
const Color appPrimaryColor = Color(0xFF00A99D);

/// The root widget of the application.
/// It sets up the MaterialApp, defines the themes, and configures the splash screen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the theme provider to listen for theme changes.
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'My Wallet',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: AnimatedSplashScreen(
        splash: const Icon(
          Icons.wallet_outlined,
          color: Colors.white,
          size: 80,
        ),
        nextScreen: const BottomNavBar(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: appPrimaryColor,
        duration: 2000, // Splash screen duration in milliseconds.
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// A utility class to hold theme data for both light and dark modes.
class AppTheme {
  /// The light theme configuration for the application.
  static final ThemeData lightTheme = ThemeData(
    primaryColor: appPrimaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: appPrimaryColor, brightness: Brightness.light),
    scaffoldBackgroundColor: Colors.grey[100],
    textTheme: GoogleFonts.latoTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: appPrimaryColor,
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );

  /// The dark theme configuration for the application.
  static final ThemeData darkTheme = ThemeData(
    primaryColor: appPrimaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: appPrimaryColor, brightness: Brightness.dark),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: appPrimaryColor,
      unselectedItemColor: Colors.grey[400],
      backgroundColor: const Color(0xFF1F1F1F),
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );
}

/// The main stateful widget that hosts the primary UI, including the bottom navigation bar.
/// It manages the app's core state, such as balance and transaction history.
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  /// The index of the currently selected screen in the bottom navigation bar.
  int _selectedIndex = 0;

  /// The current total balance of the user's wallet.
  double _totalBalance = 1234.56;

  /// The list of transactions, serving as the central source of truth for the app's data.
  final List<Transaction> _transactions = [
    Transaction(title: 'Received from Jane Smith', date: 'Yesterday', amount: 100.00, isSent: false),
    Transaction(title: 'Sent to ACME Corp', date: '2 days ago', amount: -25.50, isSent: true),
  ];

  /// Adds a new transaction to the list and updates the total balance.
  /// This function is passed as a callback to the [SendScreen].
  void _addTransaction(Transaction transaction) {
    setState(() {
      _transactions.insert(0, transaction); // Add to the top of the list.
      _totalBalance += transaction.amount; // The amount is negative for sent transactions.
    });
  }

  /// Handles tap events on the bottom navigation bar items.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The list of screens to be displayed, with necessary data passed down.
    final widgetOptions = <Widget>[
      DashboardScreen(totalBalance: _totalBalance, transactions: _transactions),
      SendScreen(onSend: _addTransaction, totalBalance: _totalBalance),
      const CardScreen(),
      HistoryScreen(transactions: _transactions),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send_outlined),
            activeIcon: Icon(Icons.send),
            label: 'Send',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_outlined),
            activeIcon: Icon(Icons.credit_card),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

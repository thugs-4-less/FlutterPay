import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:flutter_pay/main.dart'; // Import to access appPrimaryColor

/// A screen that displays the user's virtual card and its benefits.
class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Card'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(context),
            const SizedBox(height: 40),
            _buildBenefits(context),
          ],
        ),
      ),
    );
  }

  /// Builds the main virtual card widget with a glossy effect.
  Widget _buildCard(BuildContext context) {
    return Center(
      child: Card(
        elevation: 12,
        shadowColor: appPrimaryColor.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 350,
          height: 220,
          clipBehavior: Clip.antiAlias, // To keep the gloss inside the rounded corners
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [appPrimaryColor, appPrimaryColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // This positioned container creates the glossy reflection effect.
              Positioned(
                top: -100,
                left: -80,
                child: Transform.rotate(
                  angle: -math.pi / 4, // Rotates the gradient to an angle
                  child: Container(
                    height: 200,
                    width: 450,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.25),
                          Colors.white.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              // This Padding widget holds the actual content of the card.
              const Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'MY WALLET',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        Icon(Icons.contactless, color: Colors.white, size: 30),
                      ],
                    ),
                    SizedBox(height: 20),
                    Icon(Icons.sd_card, color: Colors.white70, size: 40), // Represents the card chip
                    Spacer(),
                    Text(
                      '**** **** **** 1234',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 24,
                        letterSpacing: 4,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'JOHN DOE',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          '12/28',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the section that lists the benefits of the card.
  Widget _buildBenefits(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Card Benefits',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildBenefitItem(context, Icons.language, 'Free online payments'),
        _buildBenefitItem(context, Icons.atm, 'ATM withdrawals worldwide'),
        _buildBenefitItem(context, Icons.contactless, 'Contactless payments enabled'),
        _buildBenefitItem(context, Icons.security, 'State-of-the-art security'),
      ],
    );
  }

  /// A helper widget to build a single benefit list item.
  Widget _buildBenefitItem(BuildContext context, IconData icon, String text) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: appPrimaryColor, size: 28),
        title: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

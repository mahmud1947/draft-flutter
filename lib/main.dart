import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Main function to run the app
void main() {
  runApp(const ProfitCalculatorApp());
}

// The root widget of the application
class ProfitCalculatorApp extends StatelessWidget {
  const ProfitCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profit Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Defining a dark theme for the app
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF0A192F),
        scaffoldBackgroundColor: const Color(0xFF0A192F),
        cardColor: const Color(0xFF172A46),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF172A46),
          elevation: 4,
          titleTextStyle: TextStyle(
            color: Color(0xFF64FFDA), // Cyan color for title
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF0A192F),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF64FFDA), width: 2), // Cyan border on focus
          ),
          hintStyle: const TextStyle(color: Colors.white38),
        ),
      ),
      home: const ProfitCalculatorScreen(),
    );
  }
}

// Data model for a menu item
class MenuItem {
  final String name;
  final int profitMargin;

  MenuItem({required this.name, required this.profitMargin});
}

// The main screen of the calculator
class ProfitCalculatorScreen extends StatefulWidget {
  const ProfitCalculatorScreen({super.key});

  @override
  State<ProfitCalculatorScreen> createState() => _ProfitCalculatorScreenState();
}

class _ProfitCalculatorScreenState extends State<ProfitCalculatorScreen> {
  // List of all menu items for Q-bistro
  final List<MenuItem> _items = [
    MenuItem(name: 'Classic Burger', profitMargin: 52),
    MenuItem(name: 'Burger King', profitMargin: 50),
    MenuItem(name: 'Supreme Fried Chicken', profitMargin: 46),
    MenuItem(name: 'Regular Fried Chicken', profitMargin: 46),
    MenuItem(name: 'Supreme Spicy Chicken', profitMargin: 35),
    MenuItem(name: 'Crispy Chicken Sticks', profitMargin: 47),
    MenuItem(name: 'Fire Wings', profitMargin: 42),
    MenuItem(name: 'Meat Box', profitMargin: 50),
    MenuItem(name: 'Karage Chicken', profitMargin: 39),
    MenuItem(name: 'French Fry Medium', profitMargin: 51),
    MenuItem(name: 'French Fry Large', profitMargin: 51),
    MenuItem(name: 'Spicy Chicken Sausage', profitMargin: 32),
    MenuItem(name: 'Chicken Meatballs', profitMargin: 33),
    MenuItem(name: 'Chicken Samosa', profitMargin: 26),
    MenuItem(name: 'Chicken Spring Roll', profitMargin: 20),
    MenuItem(name: 'Spicy Chicken Nuggets', profitMargin: 38),
    MenuItem(name: 'Ice Cream', profitMargin: 33),
    MenuItem(name: 'Solo Combo', profitMargin: 44),
    MenuItem(name: 'Best Buddies Combo', profitMargin: 49),
    MenuItem(name: 'Cold Coffee', profitMargin: 64),
    MenuItem(name: 'Hot Coffee', profitMargin: 57),
    MenuItem(name: 'Mint Lemonade', profitMargin: 58),
  ];

  // Controllers for each text input field
  late List<TextEditingController> _controllers;
  // State variables for total sell and total profit
  double _totalSell = 0.0;
  double _totalProfit = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and add listeners to update totals on input change
    _controllers = List.generate(_items.length, (index) {
      final controller = TextEditingController();
      controller.addListener(_calculateTotals);
      return controller;
    });
  }

  @override
  void dispose() {
    // Dispose all controllers to avoid memory leaks
    for (final controller in _controllers) {
      controller.removeListener(_calculateTotals);
      controller.dispose();
    }
    super.dispose();
  }

  // Function to calculate totals based on current input values
  void _calculateTotals() {
    double currentTotalSell = 0.0;
    double currentTotalProfit = 0.0;

    for (int i = 0; i < _items.length; i++) {
      final sellPrice = double.tryParse(_controllers[i].text) ?? 0.0;
      final profitMargin = _items[i].profitMargin;
      final profit = (sellPrice * profitMargin) / 100;

      currentTotalSell += sellPrice;
      currentTotalProfit += profit;
    }

    // Update the state to rebuild the UI with new totals
    setState(() {
      _totalSell = currentTotalSell;
      _totalProfit = currentTotalProfit;
    });
  }

  // Function to reset all input fields and totals
  void _resetAll() {
    for (final controller in _controllers) {
      controller.clear();
    }
    // _calculateTotals will be called automatically by the listeners
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Q-bistro Profit Calculator'),
        actions: [
          // Reset button in the AppBar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetAll,
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Column(
        children: [
          // List of items that can be scrolled
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final sellPrice = double.tryParse(_controllers[index].text) ?? 0.0;
                final profit = (sellPrice * item.profitMargin) / 100;
                
                // A card for each item
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.white10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Profit Margin display
                            _buildInfoChip('Profit Margin', '${item.profitMargin}%', const Color(0xFF64FFDA)),
                            const SizedBox(width: 8),
                             // Profit Amount display
                            _buildInfoChip('Profit', '৳${profit.toStringAsFixed(2)}', const Color(0xFF4CAF50)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Text field for Total Sell input
                        TextField(
                          controller: _controllers[index],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                          decoration: const InputDecoration(
                            labelText: 'Total Sell (৳)',
                            labelStyle: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Bottom summary section for totals
          _buildTotalsSection(),
        ],
      ),
    );
  }

  // Helper widget to build small info chips
  Widget _buildInfoChip(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.white70),
          children: [
            TextSpan(text: '$label: '),
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget for the total summary section at the bottom
  Widget _buildTotalsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF172A46),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          )
        ]
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Total Sell summary
            Column(
              children: [
                const Text(
                  'Total Sell',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  '৳${_totalSell.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64FFDA), // Cyan
                  ),
                ),
              ],
            ),
             // Total Profit summary
            Column(
              children: [
                const Text(
                  'Total Profit',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  '৳${_totalProfit.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50), // Green
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


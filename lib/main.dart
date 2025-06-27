import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart' as math_exp;

void main() {
  runApp(const CalculatorAPP());
}

class CalculatorAPP extends StatefulWidget {
  const CalculatorAPP({super.key});

  @override
  State<CalculatorAPP> createState() => _CalculatorAPPState();
}

class _CalculatorAPPState extends State<CalculatorAPP> {
  ThemeData _currentTheme = AppThemes.blueTheme;

  void switchTheme(ThemeData newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _currentTheme,
      home: CalculatorScreen(switchTheme: switchTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Theme data
class AppThemes {
  static final blueTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0288D1),
      brightness: Brightness.dark,
    ),
    primaryColor: const Color(0xFF00BCD4),
    primaryColorDark: const Color(0xFF0288D1),
    scaffoldBackgroundColor: Colors.black,
  );

  static final purpleTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6A00FF),
      brightness: Brightness.dark,
    ),
    primaryColor: const Color(0xFF9C27B0),
    primaryColorDark: const Color(0xFF6A00FF),
    scaffoldBackgroundColor: Colors.black,
  );

  static final greenTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF00C853),
      brightness: Brightness.dark,
    ),
    primaryColor: const Color(0xFF00C853),
    primaryColorDark: const Color(0xFF009624),
    scaffoldBackgroundColor: Colors.black,
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF212121),
      brightness: Brightness.dark,
    ),
    primaryColor: const Color(0xFF424242),
    primaryColorDark: const Color(0xFF212121),
    scaffoldBackgroundColor: Colors.black,
  );
}

class CalculatorScreen extends StatefulWidget {
  final Function(ThemeData) switchTheme;

  const CalculatorScreen({super.key, required this.switchTheme});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String output = '0';
  String _expression = '';
  double num1 = 0;
  double num2 = 0;
  String operand = '';
  List<String> calculationHistory = []; // List to store calculation history
  bool isScientificMode = false; // Toggle between basic and scientific mode
  bool isConversionMode = false; // Toggle for conversion mode
  String expression = ''; // To display the full expression

  // Conversion variables
  String selectedConversionType = 'Length';
  String fromUnit = 'Meters';
  String toUnit = 'Feet';
  double conversionValue = 0;

  // Birthday calculator variables
  DateTime? selectedDate;
  String ageResult = '';

  // Loan calculator variables
  double loanAmount = 0;
  double interestRate = 0;
  int loanTerm = 0;
  String emiResult = '';

  // Special converter variables
  // Discount calculator
  double originalPrice = 0;
  double discountPercent = 0;
  double finalPrice = 0;
  double savedAmount = 0;

  // Date calculator
  DateTime? startDate;
  DateTime? endDate;
  int daysDifference = 0;

  // Numeral system converter
  String decimalValue = '';
  String binaryValue = '';
  String octalValue = '';
  String hexValue = '';
  String inputValue = ''; // Add this variable for numeral system converter

  // BMI calculator
  double weight = 0;
  double height = 0;
  double bmi = 0;
  String bmiCategory = '';

  // GST calculator
  double basePrice = 0;
  double gstPercent = 18;
  double gstAmount = 0;
  double totalPrice = 0;

  // --- Add MIUI/HyperOS-style horizontal toggle bar for converter categories ---
  int selectedCategoryIndex = 0;
  final List<Map<String, dynamic>> essentialCategories = [
    {'icon': Icons.attach_money, 'label': 'Currency'},
    {'icon': Icons.straighten, 'label': 'Length'},
    {'icon': Icons.monitor_weight, 'label': 'Mass'},
    {'icon': Icons.thermostat, 'label': 'Temperature'},
    {'icon': Icons.crop_square, 'label': 'Area'},
    {'icon': Icons.access_time, 'label': 'Time'},
    {'icon': Icons.sd_storage, 'label': 'Data'},
    {'icon': Icons.volume_up, 'label': 'Volume'},
    {'icon': Icons.speed, 'label': 'Speed'},
    {'icon': Icons.local_offer, 'label': 'Discount'},
    {'icon': Icons.calendar_today, 'label': 'Date'},
    {'icon': Icons.calculate, 'label': 'Numeral'},
    {'icon': Icons.monitor_weight, 'label': 'BMI'},
    {'icon': Icons.receipt, 'label': 'GST'},
  ];

  // Conversion data
  final Map<String, Map<String, double>> conversionRates = {
    'Length': {
      'Meters to Feet': 3.28084,
      'Feet to Meters': 0.3048,
      'Meters to Inches': 39.3701,
      'Inches to Meters': 0.0254,
      'Meters to Centimeters': 100,
      'Centimeters to Meters': 0.01,
      'Meters to Kilometers': 0.001,
      'Kilometers to Meters': 1000,
      'Miles to Kilometers': 1.60934,
      'Kilometers to Miles': 0.621371,
      'Feet to Inches': 12,
      'Inches to Feet': 1 / 12,
      'Feet to Centimeters': 30.48,
      'Centimeters to Feet': 1 / 30.48,
      'Inches to Centimeters': 2.54,
      'Centimeters to Inches': 1 / 2.54,
      'Miles to Feet': 5280,
      'Feet to Miles': 1 / 5280,
      'Miles to Inches': 63360,
      'Inches to Miles': 1 / 63360,
    },
    'Mass': {
      'Kilograms to Pounds': 2.20462,
      'Pounds to Kilograms': 0.453592,
      'Kilograms to Grams': 1000,
      'Grams to Kilograms': 0.001,
      'Ounces to Grams': 28.3495,
      'Grams to Ounces': 0.035274,
      'Kilograms to Ounces': 35.274,
      'Ounces to Kilograms': 0.0283495,
      'Pounds to Ounces': 16,
      'Ounces to Pounds': 0.0625,
      'Pounds to Grams': 453.592,
      'Grams to Pounds': 1 / 453.592,
      'Kilograms to Tons': 0.001,
      'Tons to Kilograms': 1000,
      'Pounds to Tons': 0.0005,
      'Tons to Pounds': 2000,
    },
    'Currency': {
      'INR to USD': 0.012,
      'USD to INR': 83.25,
      'INR to EUR': 0.011,
      'EUR to INR': 90.50,
      'INR to GBP': 0.0095,
      'GBP to INR': 105.75,
      'INR to JPY': 1.45,
      'JPY to INR': 0.69,
      'INR to AED': 0.044,
      'AED to INR': 22.65,
      'INR to SAR': 0.045,
      'SAR to INR': 22.20,
      'INR to SGD': 0.016,
      'SGD to INR': 62.5,
      'USD to EUR': 0.858,
      'EUR to USD': 1.166,
      'USD to GBP': 0.732,
      'GBP to USD': 1.366,
      'USD to JPY': 145.28,
      'JPY to USD': 0.00688,
      'USD to AED': 3.67,
      'AED to USD': 0.272,
      'USD to SAR': 3.75,
      'SAR to USD': 0.267,
      'USD to SGD': 1.33,
      'SGD to USD': 0.752,
      'EUR to GBP': 0.853,
      'GBP to EUR': 1.172,
      'EUR to JPY': 169.32,
      'JPY to EUR': 0.0059,
      'GBP to JPY': 198.47,
      'JPY to GBP': 0.00504,
    },
    'Temperature': {
      'Celsius to Fahrenheit': 32,
      'Fahrenheit to Celsius': -32,
      'Celsius to Kelvin': 273.15,
      'Kelvin to Celsius': -273.15,
    },
    'Area': {
      'Square Meters to Square Feet': 10.7639,
      'Square Feet to Square Meters': 0.092903,
      'Square Meters to Square Kilometers': 0.000001,
      'Square Kilometers to Square Meters': 1000000,
      'Square Meters to Acres': 0.000247105,
      'Acres to Square Meters': 4046.86,
      'Square Meters to Hectares': 0.0001,
      'Hectares to Square Meters': 10000,
      'Square Meters to Square Miles': 0.000000386102,
      'Square Miles to Square Meters': 2589988.11,
      'Square Feet to Square Inches': 144,
      'Square Inches to Square Feet': 1 / 144,
      'Square Feet to Square Yards': 1 / 9,
      'Square Yards to Square Feet': 9,
      'Acres to Hectares': 0.404686,
      'Hectares to Acres': 2.47105,
      'Square Miles to Acres': 640,
      'Acres to Square Miles': 1 / 640,
      'Square Kilometers to Square Miles': 0.386102,
      'Square Miles to Square Kilometers': 2.58999,
    },
    'Time': {
      'Seconds to Minutes': 1 / 60,
      'Minutes to Seconds': 60,
      'Minutes to Hours': 1 / 60,
      'Hours to Minutes': 60,
      'Hours to Days': 1 / 24,
      'Days to Hours': 24,
      'Days to Weeks': 1 / 7,
      'Weeks to Days': 7,
      'Days to Years': 1 / 365,
      'Years to Days': 365,
      'Weeks to Years': 1 / 52.1429,
      'Years to Weeks': 52.1429,
      'Seconds to Hours': 1 / 3600,
      'Hours to Seconds': 3600,
      'Seconds to Days': 1 / 86400,
      'Days to Seconds': 86400,
      'Minutes to Days': 1 / 1440,
      'Days to Minutes': 1440,
      'Weeks to Months': 1 / 4.34524,
      'Months to Weeks': 4.34524,
      'Months to Years': 1 / 12,
      'Years to Months': 12,
    },
    'Data': {
      'Bytes to Kilobytes': 1 / 1024,
      'Kilobytes to Bytes': 1024,
      'Kilobytes to Megabytes': 1 / 1024,
      'Megabytes to Kilobytes': 1024,
      'Megabytes to Gigabytes': 1 / 1024,
      'Gigabytes to Megabytes': 1024,
      'Gigabytes to Terabytes': 1 / 1024,
      'Terabytes to Gigabytes': 1024,
      'Bytes to Megabytes': 1 / (1024 * 1024),
      'Megabytes to Bytes': 1024 * 1024,
      'Bytes to Gigabytes': 1 / (1024 * 1024 * 1024),
      'Gigabytes to Bytes': 1024 * 1024 * 1024,
      'Kilobytes to Gigabytes': 1 / (1024 * 1024),
      'Gigabytes to Kilobytes': 1024 * 1024,
      'Terabytes to Megabytes': 1024 * 1024,
      'Megabytes to Terabytes': 1 / (1024 * 1024),
    },
    'Volume': {
      'Milliliters to Liters': 1 / 1000,
      'Liters to Milliliters': 1000,
      'Liters to Cubic Meters': 1 / 1000,
      'Cubic Meters to Liters': 1000,
      'Milliliters to Cups': 1 / 236.588,
      'Cups to Milliliters': 236.588,
      'Milliliters to Pints': 1 / 473.176,
      'Pints to Milliliters': 473.176,
      'Milliliters to Quarts': 1 / 946.353,
      'Quarts to Milliliters': 946.353,
      'Milliliters to Gallons': 1 / 3785.41,
      'Gallons to Milliliters': 3785.41,
      'Liters to Cups': 4.22675,
      'Cups to Liters': 1 / 4.22675,
      'Liters to Pints': 2.11338,
      'Pints to Liters': 1 / 2.11338,
      'Liters to Quarts': 1.05669,
      'Quarts to Liters': 1 / 1.05669,
      'Liters to Gallons': 0.264172,
      'Gallons to Liters': 3.78541,
      'Cups to Pints': 1 / 2,
      'Pints to Cups': 2,
      'Cups to Quarts': 1 / 4,
      'Quarts to Cups': 4,
      'Cups to Gallons': 1 / 16,
      'Gallons to Cups': 16,
      'Pints to Quarts': 1 / 2,
      'Quarts to Pints': 2,
      'Pints to Gallons': 1 / 8,
      'Gallons to Pints': 8,
      'Quarts to Gallons': 1 / 4,
      'Gallons to Quarts': 4,
    },
    'Speed': {
      'Meters/second to Kilometers/hour': 3.6,
      'Kilometers/hour to Meters/second': 1 / 3.6,
      'Meters/second to Miles/hour': 2.23694,
      'Miles/hour to Meters/second': 1 / 2.23694,
      'Kilometers/hour to Miles/hour': 0.621371,
      'Miles/hour to Kilometers/hour': 1.60934,
      'Meters/second to Knots': 1.94384,
      'Knots to Meters/second': 1 / 1.94384,
      'Kilometers/hour to Knots': 0.539957,
      'Knots to Kilometers/hour': 1.852,
      'Miles/hour to Knots': 0.868976,
      'Knots to Miles/hour': 1.15078,
      'Meters/second to Feet/second': 3.28084,
      'Feet/second to Meters/second': 1 / 3.28084,
      'Kilometers/hour to Feet/second': 0.911344,
      'Feet/second to Kilometers/hour': 1.09728,
      'Miles/hour to Feet/second': 1.46667,
      'Feet/second to Miles/hour': 1 / 1.46667,
    },
  };

  final Map<String, List<String>> conversionUnits = {
    'Length': [
      'Meters',
      'Feet',
      'Inches',
      'Centimeters',
      'Kilometers',
      'Miles',
    ],
    'Mass': ['Kilograms', 'Pounds', 'Grams', 'Ounces', 'Tons'],
    'Currency': ['USD', 'EUR', 'GBP', 'JPY', 'INR', 'AED', 'SAR', 'SGD'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Area': [
      'Square Meters',
      'Square Feet',
      'Square Inches',
      'Square Yards',
      'Square Kilometers',
      'Square Miles',
      'Acres',
      'Hectares',
    ],
    'Time': ['Seconds', 'Minutes', 'Hours', 'Days', 'Weeks', 'Months', 'Years'],
    'Data': ['Bytes', 'Kilobytes', 'Megabytes', 'Gigabytes', 'Terabytes'],
    'Volume': [
      'Milliliters',
      'Liters',
      'Cubic Meters',
      'Cups',
      'Pints',
      'Quarts',
      'Gallons',
    ],
    'Speed': [
      'Meters/second',
      'Kilometers/hour',
      'Miles/hour',
      'Knots',
      'Feet/second'
    ],
  };

  // Add this helper to the _CalculatorScreenState class:
  String _formatNumber(num value) {
    if (value.isNaN || value.isInfinite) return 'Invalid';
    // Only use scientific notation for extremely large/small numbers
    if (value.abs() >= 1e12 || (value.abs() < 1e-6 && value != 0)) {
      return value.toStringAsExponential(4);
    }
    // For integers, show as integer
    if (value % 1 == 0) {
      return NumberFormat.decimalPattern().format(value);
    }
    // For decimals, show up to 8 decimals, remove trailing zeros
    String formatted = value.toStringAsFixed(8);
    formatted = formatted.replaceAll(
      RegExp(r'(\.\d*?)0+'),
      r'\1',
    ); // Remove trailing zeros after decimal
    formatted = formatted.replaceAll(RegExp(r'\.0+'), ''); // Remove .0000
    if (formatted.endsWith('.'))
      formatted = formatted.substring(0, formatted.length - 1);
    return NumberFormat.decimalPattern().format(double.parse(formatted));
  }

  // Scientific calculator state
  bool isDeg = true;
  bool isInv = false;
  String _sciExpression = '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final fontFamily = 'Poppins';

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          const _AnimatedBackground(),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Calculator header
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 24,
                    right: 20,
                    bottom: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Calculator",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const Spacer(),
                      // Top navigation icons (only 4: history, birthday, calc/scientific, converter)
                      _buildTopNavIcon(Icons.history, () {
                        _showHistoryDialog();
                      }),
                      _buildTopNavIcon(Icons.cake, () {
                        _showBirthdayCalculator();
                      }),
                      _buildTopNavIcon(Icons.science, () {
                        setState(() {
                          isScientificMode = !isScientificMode;
                          isConversionMode = false;
                        });
                      }, isActive: isScientificMode),
                      _buildTopNavIcon(Icons.swap_horiz, () {
                        setState(() {
                          isConversionMode = !isConversionMode;
                          if (isConversionMode) {
                            isScientificMode = false;
                            selectedCategoryIndex = 0;
                            selectedConversionType =
                                essentialCategories[0]['label'];
                            if (conversionUnits.containsKey(
                              selectedConversionType,
                            )) {
                              List<String> units =
                                  conversionUnits[selectedConversionType]!;
                              if (units.isNotEmpty) {
                                fromUnit = units[0];
                                toUnit = units.length > 1 ? units[1] : units[0];
                              }
                            }
                          }
                        });
                      }, isActive: isConversionMode),
                    ],
                  ),
                ),

                // Converter category bar (always visible)
                const SizedBox(height: 8),
                buildEssentialCategoryToggleBar(),
                const SizedBox(height: 12),

                // Main content
                Expanded(
                  child: isConversionMode
                      ? _buildSelectedConverter()
                      : Column(
                          children: [
                            // Calculator Display
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Expression display
                                  if (expression.isNotEmpty)
                                    Text(
                                      expression,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                      ),
                                      textAlign: TextAlign.right,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  const SizedBox(height: 8),
                                  // Current output display
                                  Text(
                                    output,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Keypad
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                child: isScientificMode
                                    ? _buildScientificKeypad()
                                    : _buildColorfulKeypad(),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavIcon(
    IconData icon,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  // Essential category toggle bar (only 4 categories)
  Widget buildEssentialCategoryToggleBar() {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: essentialCategories.length,
        itemBuilder: (context, index) {
          final category = essentialCategories[index];
          final isSelected = index == selectedCategoryIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                isConversionMode = true;
                isScientificMode = false;
                selectedCategoryIndex = index;
                selectedConversionType = category['label'];
                print('Set selectedCategoryIndex to $selectedCategoryIndex');
                print('Set selectedConversionType to $selectedConversionType');
                if (conversionUnits.containsKey(category['label'])) {
                  List<String> units = conversionUnits[category['label']]!;
                  if (units.isNotEmpty) {
                    fromUnit = units[0];
                    toUnit = units.length > 1 ? units[1] : units[0];
                    print('Set fromUnit to $fromUnit and toUnit to $toUnit');
                  }
                }
                _expression = '0';
                output = '0';
                if (category['label'] == 'Time') {
                  print('Calling _performTimeConversion()');
                  _performTimeConversion();
                } else {
                  print('Calling _performConversion()');
                  _performConversion();
                }
              });
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category['icon'], color: Colors.white, size: 28),
                  const SizedBox(height: 6),
                  Text(
                    category['label'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorfulKeypad() {
    return Column(
      children: [
        // Row 1: Clear, Delete, Percentage, Divide
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildColorfulButton('C', Colors.red.shade400)),
              SizedBox(width: 8),
              Expanded(child: _buildColorfulButton('DEL', Colors.red.shade400)),
              SizedBox(width: 8),
              Expanded(child: _buildColorfulButton('%', Colors.amber.shade400)),
              SizedBox(width: 8),
              Expanded(child: _buildColorfulButton('/', Colors.amber.shade400)),
            ],
          ),
        ),
        SizedBox(height: 8),

        // Row 2: 7, 8, 9, Multiply
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: _buildColorfulButton('7', Colors.deepPurple.shade400)),
              SizedBox(width: 8),
              Expanded(child: _buildColorfulButton('8', Colors.blue.shade400)),
              SizedBox(width: 8),
              Expanded(child: _buildColorfulButton('9', Colors.teal.shade400)),
              SizedBox(width: 8),
              Expanded(child: _buildColorfulButton('*', Colors.amber.shade400)),
            ],
          ),
        ),
        SizedBox(height: 8),

        // Row 3: 4, 5, 6, Minus
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildColorfulButton('4', Colors.green.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildColorfulButton('5', Colors.indigo.shade400)),
              SizedBox(width: 8),
              Expanded(child: _buildColorfulButton('6', Colors.pink.shade400)),
              SizedBox(width: 8),
              Expanded(child: _buildColorfulButton('-', Colors.amber.shade400)),
            ],
          ),
        ),
        SizedBox(height: 8),

        // Row 4: 1, 2, 3, Plus
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: _buildColorfulButton('1', Colors.deepOrange.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildColorfulButton('2', Colors.lightGreen.shade400)),
              SizedBox(width: 8),
              Expanded(child: _buildColorfulButton('3', Colors.cyan.shade400)),
              SizedBox(width: 8),
              Expanded(child: _buildColorfulButton('+', Colors.amber.shade400)),
            ],
          ),
        ),
        SizedBox(height: 8),

        // Row 5: 0 (spans 2 columns), Decimal, Equals
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildColorfulButton('0', Colors.amber.shade300),
              ),
              SizedBox(width: 8),
              Expanded(child: _buildColorfulButton('.', Colors.grey.shade700)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildColorfulButton('=', Colors.deepPurple.shade500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorfulButton(String text, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _handleButtonPress(text);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _handleButtonPress(String button) {
    setState(() {
      if (button == 'C') {
        _clear();
      } else if (button == 'DEL') {
        _delete();
      } else if (button == '=') {
        _calculate();
      } else if (button == '%') {
        _percent();
      } else {
        _append(button);
      }
    });
  }

  void _clear() {
    output = '0';
    _expression = '';
    expression = '';
  }

  void _delete() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      output = _expression.isEmpty ? '0' : _expression;
    }
  }

  void _append(String button) {
    // Prevent multiple decimals in a number
    if (button == '.') {
      final parts = _expression.split(RegExp(r'[+\-*/]'));
      if (parts.isNotEmpty && parts.last.contains('.')) return;
      if (_expression.isEmpty) _expression = '0';
    }
    // Prevent consecutive operators
    if ('+-*/'.contains(button)) {
      if (_expression.isEmpty) return;
      if ('+-*/'.contains(_expression[_expression.length - 1])) {
        _expression = _expression.substring(0, _expression.length - 1) + button;
        output = _expression;
        return;
      }
    }
    // Prevent leading zeros
    if (_expression == '0' && button != '.') {
      _expression = button;
    } else {
      _expression += button;
    }
    output = _expression;
  }

  void _percent() {
    if (_expression.isEmpty) return;
    try {
      final math_exp.Parser p = math_exp.Parser();
      final exp = p.parse(_expression);
      final math_exp.ContextModel cm = math_exp.ContextModel();
      double val = exp.evaluate(math_exp.EvaluationType.REAL, cm);
      val = val / 100.0;
      _expression = val.toString();
      output = _expression;
    } catch (e) {
      output = 'Error';
    }
  }

  void _calculate() {
    if (_expression.isEmpty) return;
    try {
      String expStr = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-');
      math_exp.Parser p = math_exp.Parser();
      math_exp.Expression exp = p.parse(expStr);
      math_exp.ContextModel cm = math_exp.ContextModel();
      double eval = exp.evaluate(math_exp.EvaluationType.REAL, cm);
      output = _formatNumber(eval);
      calculationHistory.add('$_expression = $output');
      _expression = eval.toString();
    } catch (e) {
      output = 'Error';
    }
  }

  Widget _buildScientificKeypad() {
    // Use the same color scheme as the normal calculator
    return Column(
      children: [
        // Row 1: √, π, ^, !
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: _buildScientificColorfulButton(
                      '√', Colors.teal.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      'π', Colors.purple.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '^', Colors.amber.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '!', Colors.purple.shade400)),
            ],
          ),
        ),
        SizedBox(height: 8),
        // Row 2: DEG, sin, cos, tan
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: _buildScientificColorfulButton(
                      'DEG', Colors.grey.shade700)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      'sin', Colors.blueGrey.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      'cos', Colors.blueGrey.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      'tan', Colors.blueGrey.shade400)),
            ],
          ),
        ),
        SizedBox(height: 8),
        // Row 3: INV, e, ln, log
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: _buildScientificColorfulButton(
                      'INV', Colors.grey.shade700)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      'e', Colors.purple.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      'ln', Colors.blueGrey.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      'log', Colors.blueGrey.shade400)),
            ],
          ),
        ),
        SizedBox(height: 8),
        // Row 4: AC, (, ), %, ÷
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: _buildScientificColorfulButton(
                      'AC', Colors.red.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '(', Colors.grey.shade700)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      ')', Colors.grey.shade700)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '%', Colors.amber.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '÷', Colors.amber.shade400)),
            ],
          ),
        ),
        SizedBox(height: 8),
        // Row 5: 7, 8, 9, ×
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: _buildScientificColorfulButton(
                      '7', Colors.deepPurple.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '8', Colors.blue.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '9', Colors.teal.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '×', Colors.amber.shade400)),
            ],
          ),
        ),
        SizedBox(height: 8),
        // Row 6: 4, 5, 6, −
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: _buildScientificColorfulButton(
                      '4', Colors.green.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '5', Colors.indigo.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '6', Colors.pink.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '−', Colors.amber.shade400)),
            ],
          ),
        ),
        SizedBox(height: 8),
        // Row 7: 1, 2, 3, +
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: _buildScientificColorfulButton(
                      '1', Colors.deepOrange.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '2', Colors.lightGreen.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '3', Colors.cyan.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '+', Colors.amber.shade400)),
            ],
          ),
        ),
        SizedBox(height: 8),
        // Row 8: 0, ., ⌫, =
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: _buildScientificColorfulButton(
                      '0', Colors.amber.shade300)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '.', Colors.grey.shade700)),
              SizedBox(width: 8),
              Expanded(
                  child:
                      _buildScientificColorfulButton('⌫', Colors.red.shade400)),
              SizedBox(width: 8),
              Expanded(
                  child: _buildScientificColorfulButton(
                      '=', Colors.deepPurple.shade500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScientificColorfulButton(String text, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _handleScientificButtonPress(text);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: text.length > 3 ? 18 : 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _handleScientificButtonPress(String button) {
    setState(() {
      if (button == 'AC') {
        _sciExpression = '';
        output = '0';
      } else if (button == '⌫') {
        if (_sciExpression.isNotEmpty) {
          _sciExpression =
              _sciExpression.substring(0, _sciExpression.length - 1);
          output = _sciExpression.isEmpty ? '0' : _sciExpression;
        }
      } else if (button == '=') {
        _evaluateScientificExpression();
      } else if (button == 'DEG') {
        isDeg = !isDeg;
      } else if (button == 'INV') {
        isInv = !isInv;
      } else {
        _appendScientific(button);
      }
    });
  }

  void _appendScientific(String button) {
    // Map button to math_expressions syntax
    final Map<String, String> sciMap = {
      'π': 'pi',
      'e': 'e',
      '÷': '/',
      '×': '*',
      '−': '-',
      '^': '^',
      '(': '(',
      ')': ')',
      '%': '/100',
      '√': 'sqrt(',
      '!': '!',
      '.': '.',
      '+': '+',
    };
    final Map<String, String> funcMap = {
      'sin': isInv ? 'arcsin(' : 'sin(',
      'cos': isInv ? 'arccos(' : 'cos(',
      'tan': isInv ? 'arctan(' : 'tan(',
      'ln': isInv ? 'exp(' : 'ln(',
      'log': isInv ? '10^(' : 'log(',
    };
    if (funcMap.containsKey(button)) {
      _sciExpression += funcMap[button]!;
    } else if (sciMap.containsKey(button)) {
      _sciExpression += sciMap[button]!;
    } else {
      _sciExpression += button;
    }
    output = _sciExpression;
  }

  void _evaluateScientificExpression() {
    try {
      String expStr = _sciExpression;
      // Auto-complete missing closing parentheses
      int open = '('.allMatches(expStr).length;
      int close = ')'.allMatches(expStr).length;
      if (open > close) {
        expStr += ')' * (open - close);
      }
      // Replace sqrt( with sqrt, handle factorial, and degree/radian for trig
      expStr = expStr.replaceAll('sqrt(', 'sqrt');
      // Replace factorials with math_expressions syntax
      expStr =
          expStr.replaceAllMapped(RegExp(r'(\d+)!'), (m) => 'fact(${m[1]})');
      // If DEG mode, wrap trig function arguments with radians conversion
      if (isDeg) {
        for (final func in [
          'sin',
          'cos',
          'tan',
          'arcsin',
          'arccos',
          'arctan'
        ]) {
          expStr = expStr.replaceAllMapped(
            RegExp(r'$func\\s*\\(([^()]*)\\)'),
            (m) => '$func((${m[1]})*pi/180)',
          );
        }
      }
      math_exp.Parser p = math_exp.Parser();
      math_exp.Expression exp = p.parse(expStr);
      math_exp.ContextModel cm = math_exp.ContextModel();
      double eval = exp.evaluate(math_exp.EvaluationType.REAL, cm);
      output = _formatNumber(eval);
      calculationHistory.add('$_sciExpression = $output');
      _sciExpression = eval.toString();
    } catch (e) {
      output = 'Error';
    }
  }

  Widget _buildSelectedConverter() {
    final label = essentialCategories[selectedCategoryIndex]['label'];
    print('Selected converter: $label with index $selectedCategoryIndex');

    // Handle special converters that need custom UI
    switch (label) {
      case 'Discount':
        return _buildDiscountCalculator();
      case 'Date':
        return _buildDateCalculator();
      case 'Numeral':
        return _buildNumeralSystemConverter();
      case 'BMI':
        return _buildBMICalculator();
      case 'GST':
        return _buildGSTCalculator();
      case 'Time':
        print('Building Time converter');
        return _buildTimeConverter();
      default:
        return _buildConversionInterface(type: label);
    }
  }

  void _performConversion() {
    if (_expression == '0' || _expression.isEmpty) return;
    try {
      double inputValue = double.parse(_expression);
      double result = 0;
      String convType = selectedConversionType;
      String from = fromUnit;
      String to = toUnit;

      // Handle special converters first
      switch (convType) {
        case 'Discount':
          _calculateDiscount(inputValue);
          return;
        case 'Date':
          _calculateDateDifference();
          return;
        case 'Numeral':
          _convertNumeralSystem();
          return;
        case 'BMI':
          _calculateBMI();
          return;
        case 'GST':
          _calculateGST(inputValue);
          return;
      }

      // Handle temperature conversions (special cases)
      if (convType == 'Temperature') {
        print('Temperature conversion: $from to $to');
        result = _convertTemperature(inputValue, from, to);
      } else {
        // Handle all other conversions using conversion rates
        String conversionKey = '$from to $to';
        print('Trying conversion key: $conversionKey');
        if (conversionRates[convType] != null &&
            conversionRates[convType]!.containsKey(conversionKey)) {
          result = inputValue * conversionRates[convType]![conversionKey]!;
        } else {
          // Try reverse conversion
          String reverseKey = '$to to $from';
          print('Trying reverse key: $reverseKey');
          if (conversionRates[convType] != null &&
              conversionRates[convType]!.containsKey(reverseKey)) {
            result = inputValue / conversionRates[convType]![reverseKey]!;
          } else {
            // Try converting through a common unit (robust fallback)
            print('Trying common unit fallback for $convType');
            result = _convertThroughCommonUnit(inputValue, convType, from, to);
            // If still no conversion, show message
            if (result == inputValue && from != to) {
              setState(() {
                output = 'Conversion not available';
              });
              return;
            }
          }
        }
      }

      setState(() {
        output = _formatNumber(result);
      });
      print('Set output to: $output');
    } catch (e) {
      setState(() {
        output = 'Error';
        print('Conversion error: $e');
      });
    }
  }

  Widget _buildConverterKeypad({required void Function(String) onKeyTap}) {
    final List<String> keys = [
      '7',
      '8',
      '9',
      'DEL',
      '4',
      '5',
      '6',
      'C',
      '1',
      '2',
      '3',
      '.',
      '0',
    ];

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];
        Color buttonColor = Colors.white.withOpacity(0.1);
        Color textColor = Colors.white;

        // Assign different colors to function keys
        if (key == 'DEL' || key == 'C') {
          buttonColor = Colors.red.shade400.withOpacity(0.8);
        }

        return GestureDetector(
          onTap: () {
            print('Tapped key: $key');
            onKeyTap(key);
          },
          child: Container(
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                key,
                style: TextStyle(
                  color: textColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize default conversion units
    if (conversionUnits.containsKey(selectedConversionType)) {
      List<String> units = conversionUnits[selectedConversionType]!;
      if (units.isNotEmpty) {
        fromUnit = units[0];
        toUnit = units.length > 1 ? units[1] : units[0];
      }
    }

    // Add listener to handle category changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize the converter based on the selected category
      final category = essentialCategories[selectedCategoryIndex]['label'];
      if (category == 'Time') {
        _performTimeConversion();
      } else {
        _performConversion();
      }
    });
  }

  // Convert through a common unit when direct conversion is not available
  double _convertThroughCommonUnit(
      double value, String convType, String from, String to) {
    // Define common units for each conversion type
    Map<String, String> commonUnits = {
      'Length': 'Meters',
      'Mass': 'Kilograms',
      'Currency': 'USD',
      'Area': 'Square Meters',
      'Time': 'Seconds',
      'Data': 'Bytes',
      'Volume': 'Liters',
      'Speed': 'Meters/second',
    };

    String commonUnit = commonUnits[convType] ?? '';
    if (commonUnit.isEmpty) return value;

    // Convert from source to common unit
    double valueInCommon =
        _convertToCommonUnit(value, convType, from, commonUnit);

    // Convert from common unit to target
    return _convertFromCommonUnit(valueInCommon, convType, commonUnit, to);
  }

  double _convertToCommonUnit(
      double value, String convType, String from, String commonUnit) {
    if (from == commonUnit) return value;

    String conversionKey = '$from to $commonUnit';
    if (conversionRates[convType] != null &&
        conversionRates[convType]!.containsKey(conversionKey)) {
      return value * conversionRates[convType]![conversionKey]!;
    }

    String reverseKey = '$commonUnit to $from';
    if (conversionRates[convType] != null &&
        conversionRates[convType]!.containsKey(reverseKey)) {
      return value / conversionRates[convType]![reverseKey]!;
    }

    return value; // Fallback
  }

  double _convertFromCommonUnit(
      double value, String convType, String commonUnit, String to) {
    if (to == commonUnit) return value;

    String conversionKey = '$commonUnit to $to';
    if (conversionRates[convType] != null &&
        conversionRates[convType]!.containsKey(conversionKey)) {
      return value * conversionRates[convType]![conversionKey]!;
    }

    String reverseKey = '$to to $commonUnit';
    if (conversionRates[convType] != null &&
        conversionRates[convType]!.containsKey(reverseKey)) {
      return value / conversionRates[convType]![reverseKey]!;
    }

    return value; // Fallback
  }

  // Show calculation history dialog
  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Calculation History'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            children: calculationHistory
                .map((item) => ListTile(title: Text(item)))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  // Show birthday calculator modal (full implementation)
  void _showBirthdayCalculator() async {
    DateTime? birthday = selectedDate;
    final now = DateTime.now();

    // Helper: Calculate age in years, months, days
    Map<String, int> _calculateAge(DateTime birth, DateTime today) {
      int years = today.year - birth.year;
      int months = today.month - birth.month;
      int days = today.day - birth.day;
      if (days < 0) {
        months--;
        final prevMonth = DateTime(today.year, today.month, 0);
        days += prevMonth.day;
      }
      if (months < 0) {
        years--;
        months += 12;
      }
      return {'years': years, 'months': months, 'days': days};
    }

    // Helper: Next birthday
    DateTime _nextBirthday(DateTime birth, DateTime today) {
      DateTime next = DateTime(today.year, birth.month, birth.day);
      if (next.isBefore(today) || next.isAtSameMomentAs(today)) {
        next = DateTime(today.year + 1, birth.month, birth.day);
      }
      return next;
    }

    // Helper: Day of week
    String _weekdayName(DateTime date) {
      const days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      return days[date.weekday - 1];
    }

    // Helper: Total lived
    Map<String, int> _totalLived(DateTime birth, DateTime today) {
      final days = today.difference(birth).inDays;
      final weeks = days ~/ 7;
      final months =
          ((today.year - birth.year) * 12 + today.month - birth.month) -
              (today.day < birth.day ? 1 : 0);
      return {'days': days, 'weeks': weeks, 'months': months};
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Use birthday or default
            final DateTime effectiveBirthday =
                birthday ?? DateTime(now.year - 18, now.month, now.day);
            final age = _calculateAge(effectiveBirthday, now);
            final nextBday = _nextBirthday(effectiveBirthday, now);
            final daysToNext = nextBday.difference(now).inDays;
            final lived = _totalLived(effectiveBirthday, now);
            final weekday = _weekdayName(effectiveBirthday);
            final nextBdayWeekday = _weekdayName(nextBday);

            // Fun facts calculations
            final totalDays = lived['days'] ?? 0;
            final totalYears = age['years'] ?? 0;
            final heartBeats = totalDays * 24 * 60 * 70; // 70 bpm
            final breaths = totalDays * 24 * 60 * 16; // 16 breaths/min
            final hoursSlept = totalDays * 8;
            final distanceSun = (totalYears * 940000000).toDouble(); // km
            final fullMoons = (totalDays / 29.53).floor();

            String formatBigInt(int n) {
              if (n >= 1000000000)
                return (n / 1000000000).toStringAsFixed(2) + 'B';
              if (n >= 1000000) return (n / 1000000).toStringAsFixed(2) + 'M';
              if (n >= 1000) return (n / 1000).toStringAsFixed(2) + 'K';
              return n.toString();
            }

            String formatBigDouble(double n) {
              if (n >= 1e9) return (n / 1e9).toStringAsFixed(2) + 'B km';
              if (n >= 1e6) return (n / 1e6).toStringAsFixed(2) + 'M km';
              if (n >= 1e3) return (n / 1e3).toStringAsFixed(2) + 'K km';
              return n.toStringAsFixed(0) + ' km';
            }

            // Zodiac sign helper
            Map<String, dynamic>? getZodiac(DateTime date) {
              final month = date.month;
              final day = date.day;
              // List of zodiac signs with their date ranges and icons
              final zodiacs = [
                {
                  'name': 'Capricorn',
                  'icon': Icons.terrain,
                  'start': [12, 22],
                  'end': [1, 19]
                },
                {
                  'name': 'Aquarius',
                  'icon': Icons.water,
                  'start': [1, 20],
                  'end': [2, 18]
                },
                {
                  'name': 'Pisces',
                  'icon': Icons.pool,
                  'start': [2, 19],
                  'end': [3, 20]
                },
                {
                  'name': 'Aries',
                  'icon': Icons.whatshot,
                  'start': [3, 21],
                  'end': [4, 19]
                },
                {
                  'name': 'Taurus',
                  'icon': Icons.spa,
                  'start': [4, 20],
                  'end': [5, 20]
                },
                {
                  'name': 'Gemini',
                  'icon': Icons.wb_twighlight,
                  'start': [5, 21],
                  'end': [6, 20]
                },
                {
                  'name': 'Cancer',
                  'icon': Icons.brightness_3,
                  'start': [6, 21],
                  'end': [7, 22]
                },
                {
                  'name': 'Leo',
                  'icon': Icons.wb_sunny,
                  'start': [7, 23],
                  'end': [8, 22]
                },
                {
                  'name': 'Virgo',
                  'icon': Icons.grass,
                  'start': [8, 23],
                  'end': [9, 22]
                },
                {
                  'name': 'Libra',
                  'icon': Icons.balance,
                  'start': [9, 23],
                  'end': [10, 22]
                },
                {
                  'name': 'Scorpio',
                  'icon': Icons.bug_report,
                  'start': [10, 23],
                  'end': [11, 21]
                },
                {
                  'name': 'Sagittarius',
                  'icon': Icons.travel_explore,
                  'start': [11, 22],
                  'end': [12, 21]
                },
              ];
              for (final zRaw in zodiacs) {
                final z = zRaw as Map<String, dynamic>;
                final startMonth = z['start'][0], startDay = z['start'][1];
                final endMonth = z['end'][0], endDay = z['end'][1];
                if ((month == startMonth && day >= startDay) ||
                    (month == endMonth && day <= endDay) ||
                    (startMonth > endMonth &&
                        ((month == startMonth && day >= startDay) ||
                            (month == endMonth && day <= endDay)))) {
                  return z;
                }
              }
              return zodiacs[0]; // fallback
            }

            final zodiac = (() {
              final z = getZodiac(effectiveBirthday);
              if (z != null && z['icon'] != null && z['name'] != null) return z;
              return {'name': 'Capricorn', 'icon': Icons.terrain};
            })();
            final IconData zodiacIcon = zodiac['icon'] as IconData;
            final String zodiacName = zodiac['name'] as String;

            return Container(
              padding: EdgeInsets.only(
                left: 0,
                right: 0,
                top: 0,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.cake,
                                color: Colors.amber.shade400, size: 28),
                            SizedBox(width: 10),
                            Text(
                              'Birthday Calculator',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Birthday picker
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: effectiveBirthday,
                              firstDate: DateTime(1900),
                              lastDate: now,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.dark(
                                      primary: Colors.amber.shade400,
                                      onPrimary: Colors.white,
                                      surface: Colors.black87,
                                      onSurface: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setModalState(() {
                                birthday = picked;
                                selectedDate = picked;
                              });
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade800,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  'Birthday: ' +
                                      '${effectiveBirthday.year.toString().padLeft(4, '0')}' +
                                      '-${effectiveBirthday.month.toString().padLeft(2, '0')}' +
                                      '-${effectiveBirthday.day.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 18),
                        // Age
                        _BirthdayInfoCard(
                          icon: Icons.cake,
                          title: 'Your Age',
                          value:
                              '${age['years']} years, ${age['months']} months, ${age['days']} days',
                        ),
                        SizedBox(height: 10),
                        // Day of week
                        _BirthdayInfoCard(
                          icon: Icons.calendar_today,
                          title: 'Day of the week',
                          value: weekday,
                        ),
                        SizedBox(height: 10),
                        // Next birthday
                        _BirthdayInfoCard(
                          icon: Icons.event,
                          title: 'Next Birthday',
                          value:
                              '${nextBday.year}-${nextBday.month.toString().padLeft(2, '0')}-${nextBday.day.toString().padLeft(2, '0')}  ($daysToNext days left)',
                        ),
                        SizedBox(height: 10),
                        // Total lived
                        _BirthdayInfoCard(
                          icon: Icons.timelapse,
                          title: 'Total Lived',
                          value:
                              '${lived['days']} days, ${lived['weeks']} weeks, ${lived['months']} months',
                        ),
                        SizedBox(height: 10),
                        // Fun facts
                        _BirthdayInfoCard(
                          icon: Icons.public,
                          title: 'Earth Rotations',
                          value: '$totalDays',
                        ),
                        SizedBox(height: 10),
                        _BirthdayInfoCard(
                          icon: Icons.favorite,
                          title: 'Heartbeats',
                          value: formatBigInt(heartBeats),
                        ),
                        SizedBox(height: 10),
                        _BirthdayInfoCard(
                          icon: Icons.air,
                          title: 'Breaths Taken',
                          value: formatBigInt(breaths),
                        ),
                        SizedBox(height: 10),
                        _BirthdayInfoCard(
                          icon: Icons.nights_stay,
                          title: 'Hours Slept',
                          value: formatBigInt(hoursSlept),
                        ),
                        SizedBox(height: 10),
                        _BirthdayInfoCard(
                          icon: Icons.brightness_2,
                          title: 'Full Moons Seen',
                          value: '$fullMoons',
                        ),
                        SizedBox(height: 10),
                        // Zodiac sign card
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 14, top: 10),
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade400,
                                Colors.purple.shade700
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.shade400.withOpacity(0.18),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(zodiacIcon, color: Colors.white, size: 28),
                              SizedBox(width: 14),
                              Text(
                                zodiacName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Zodiac',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Perform time conversion (stub)
  void _performTimeConversion() {
    // You can implement the full logic as needed
    setState(() {
      output = 'Time conversion result';
    });
  }

  // Discount calculation logic - Complete implementation
  void _calculateDiscount(double value) {
    if (originalPrice == 0) {
      originalPrice = value;
    } else {
      discountPercent = value;
      savedAmount = originalPrice * (discountPercent / 100);
      finalPrice = originalPrice - savedAmount;
    }

    setState(() {
      output = _formatNumber(finalPrice);
    });
  }

  // Discount calculator UI - Complete implementation
  Widget _buildDiscountCalculator() {
    return Column(
      children: [
        // Input Cards
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Original Price Input
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Original Price',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      originalPrice == 0 ? '0' : originalPrice.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Discount Percentage Input
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discount Percentage',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      discountPercent == 0 ? '0' : discountPercent.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Results
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Final Price
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade400.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Final Price',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatNumber(finalPrice),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Saved Amount
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade400, Colors.red.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade400.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount Saved',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatNumber(savedAmount),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Keypad
        Expanded(
          child: _buildConverterKeypad(onKeyTap: (val) {
            setState(() {
              if (val == 'C') {
                originalPrice = 0;
                discountPercent = 0;
                finalPrice = 0;
                savedAmount = 0;
                _expression = '';
                output = '0';
              } else if (val == 'DEL') {
                if (_expression.isNotEmpty) {
                  _expression =
                      _expression.substring(0, _expression.length - 1);
                }
                if (_expression.isEmpty) {
                  originalPrice = 0;
                  discountPercent = 0;
                  finalPrice = 0;
                  savedAmount = 0;
                  output = '0';
                }
              } else {
                if (val == '.' && _expression.contains('.')) return;
                _expression += val;
                _calculateDiscount(double.tryParse(_expression) ?? 0);
              }
            });
          }),
        ),
      ],
    );
  }

  // Date calculator UI - Complete implementation
  Widget _buildDateCalculator() {
    return Column(
      children: [
        // Start Date Card
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start Date',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: Colors.amber.shade400,
                              onPrimary: Colors.white,
                              surface: Colors.black87,
                              onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        startDate = picked;
                        _calculateDateDifference();
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          startDate != null
                              ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                              : 'Select Start Date',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // End Date Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'End Date',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: Colors.amber.shade400,
                              onPrimary: Colors.white,
                              surface: Colors.black87,
                              onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        endDate = picked;
                        _calculateDateDifference();
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          endDate != null
                              ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                              : 'Select End Date',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Result Card
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade400.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Days Difference',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  daysDifference.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (startDate != null && endDate != null)
                  Text(
                    '${startDate!.day}/${startDate!.month}/${startDate!.year} to ${endDate!.day}/${endDate!.month}/${endDate!.year}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Clear Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  startDate = null;
                  endDate = null;
                  daysDifference = 0;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Clear Dates',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        const Spacer(),
      ],
    );
  }

  // Numeral system converter UI - Complete implementation
  Widget _buildNumeralSystemConverter() {
    final List<String> units = ['Decimal', 'Binary', 'Octal', 'Hexadecimal'];
    // Ensure fromUnit and toUnit are always valid for numeral system
    if (!units.contains(fromUnit)) fromUnit = units[0];
    if (!units.contains(toUnit)) toUnit = units[1];
    return Column(
      children: [
        // Input Card
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Input Value',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  inputValue.isEmpty ? '0' : inputValue,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Unit Selectors
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            children: [
              // From Unit Dropdown
              Flexible(
                flex: 4,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 140),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: fromUnit,
                      dropdownColor: Colors.black87,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                      isExpanded: true,
                      itemHeight: 48,
                      items: units.map((String unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(unit, overflow: TextOverflow.ellipsis),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            fromUnit = newValue;
                            _convertNumeralSystem();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Swap Button
              SizedBox(
                width: 44,
                height: 44,
                child: Material(
                  color: Colors.amber.shade400,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() {
                        String temp = fromUnit;
                        fromUnit = toUnit;
                        toUnit = temp;
                        _convertNumeralSystem();
                      });
                    },
                    child: const Icon(Icons.swap_horiz,
                        color: Colors.white, size: 24),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // To Unit Dropdown
              Flexible(
                flex: 4,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 140),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: toUnit,
                      dropdownColor: Colors.black87,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                      isExpanded: true,
                      itemHeight: 48,
                      items: units.map((String unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(unit, overflow: TextOverflow.ellipsis),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            toUnit = newValue;
                            _convertNumeralSystem();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Result Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade400, Colors.orange.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.shade400.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Result',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  output,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$fromUnit → $toUnit',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Keypad
        Expanded(
          child: _buildConverterKeypad(onKeyTap: (val) {
            setState(() {
              if (val == 'C') {
                inputValue = '';
                output = '0';
              } else if (val == 'DEL') {
                if (inputValue.isNotEmpty) {
                  inputValue = inputValue.substring(0, inputValue.length - 1);
                }
                if (inputValue.isEmpty) output = '0';
              } else {
                // Validate input based on numeral system
                if (_isValidInput(val, fromUnit)) {
                  inputValue += val;
                }
              }
              _convertNumeralSystem();
            });
          }),
        ),
      ],
    );
  }

  // Helper method to validate input based on numeral system
  bool _isValidInput(String val, String system) {
    if (val == '.') return false; // No decimals in numeral systems

    switch (system) {
      case 'Binary':
        return val == '0' || val == '1';
      case 'Octal':
        return int.tryParse(val) != null && int.parse(val) < 8;
      case 'Decimal':
        return int.tryParse(val) != null;
      case 'Hexadecimal':
        return RegExp(r'^[0-9A-Fa-f]$').hasMatch(val);
      default:
        return true;
    }
  }

  // Date difference calculation logic - Complete implementation
  void _calculateDateDifference() {
    if (startDate != null && endDate != null) {
      final difference = endDate!.difference(startDate!);
      setState(() {
        daysDifference = difference.inDays;
        output = daysDifference.toString();
      });
    }
  }

  // Numeral system conversion logic - Complete implementation
  void _convertNumeralSystem() {
    if (inputValue.isEmpty) {
      setState(() {
        output = '0';
      });
      return;
    }

    try {
      int decimalValue = 0;
      String sanitizedInput = inputValue.trim();
      // Prevent negative numbers and invalid characters
      if (sanitizedInput.startsWith('-'))
        throw Exception('Negative not supported');
      // Convert input to decimal first
      switch (fromUnit) {
        case 'Decimal':
          if (!RegExp(r'^[0-9]+ ').hasMatch(sanitizedInput))
            throw Exception('Invalid');
          decimalValue = int.parse(sanitizedInput);
          break;
        case 'Binary':
          if (!RegExp(r'^[01]+ ').hasMatch(sanitizedInput))
            throw Exception('Invalid');
          decimalValue = int.parse(sanitizedInput, radix: 2);
          break;
        case 'Octal':
          if (!RegExp(r'^[0-7]+ ').hasMatch(sanitizedInput))
            throw Exception('Invalid');
          decimalValue = int.parse(sanitizedInput, radix: 8);
          break;
        case 'Hexadecimal':
          if (!RegExp(r'^[0-9A-Fa-f]+ ').hasMatch(sanitizedInput))
            throw Exception('Invalid');
          decimalValue = int.parse(sanitizedInput, radix: 16);
          break;
        default:
          throw Exception('Invalid system');
      }

      // Convert decimal to target system
      String result = '';
      switch (toUnit) {
        case 'Decimal':
          result = decimalValue.toString();
          break;
        case 'Binary':
          result = decimalValue.toRadixString(2);
          break;
        case 'Octal':
          result = decimalValue.toRadixString(8);
          break;
        case 'Hexadecimal':
          result = decimalValue.toRadixString(16).toUpperCase();
          break;
        default:
          result = decimalValue.toString();
      }

      setState(() {
        output = result;
      });
    } catch (e) {
      setState(() {
        output = 'Invalid Input';
      });
    }
  }

  // BMI calculation logic - Complete implementation
  void _calculateBMI() {
    if (_expression.isEmpty) return;

    double value = double.tryParse(_expression) ?? 0;
    if (value <= 0) return;

    setState(() {
      // Determine which value to update based on current state
      if (weight == 0) {
        // First input is weight
        weight = value;
        _expression = '';
      } else if (height == 0) {
        // Second input is height
        height = value;
        _expression = '';

        // Calculate BMI when both values are available
        if (height > 0) {
          bmi = weight / (height * height);

          // Determine BMI category
          if (bmi < 18.5) {
            bmiCategory = 'Underweight';
          } else if (bmi < 25) {
            bmiCategory = 'Normal Weight';
          } else if (bmi < 30) {
            bmiCategory = 'Overweight';
          } else {
            bmiCategory = 'Obese';
          }

          output = _formatNumber(bmi);
        }
      } else {
        // Both values are set, allow updating either weight or height
        // Determine which one to update based on which toggle is active
        bool isEnteringWeight = weight == 0 || (weight > 0 && height == 0);

        if (isEnteringWeight) {
          weight = value;
        } else {
          height = value;
        }

        _expression = '';

        // Recalculate BMI
        if (height > 0) {
          bmi = weight / (height * height);

          // Determine BMI category
          if (bmi < 18.5) {
            bmiCategory = 'Underweight';
          } else if (bmi < 25) {
            bmiCategory = 'Normal Weight';
          } else if (bmi < 30) {
            bmiCategory = 'Overweight';
          } else {
            bmiCategory = 'Obese';
          }

          output = _formatNumber(bmi);
        }
      }
    });
  }

  // GST calculation logic - Complete implementation
  void _calculateGST(double value) {
    if (basePrice == 0) {
      basePrice = value;
    } else {
      gstPercent = value;
      gstAmount = basePrice * (gstPercent / 100);
      totalPrice = basePrice + gstAmount;
    }

    setState(() {
      output = _formatNumber(totalPrice);
    });
  }

  // Temperature conversion logic - Complete implementation
  double _convertTemperature(double value, String from, String to) {
    // First convert to Celsius as base unit
    double celsius;

    switch (from) {
      case 'Celsius':
        celsius = value;
        break;
      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
      default:
        return value;
    }

    // Then convert from Celsius to target unit
    switch (to) {
      case 'Celsius':
        return celsius;
      case 'Fahrenheit':
        return celsius * 9 / 5 + 32;
      case 'Kelvin':
        return celsius + 273.15;
      default:
        return value;
    }
  }

  // Generic conversion interface for standard converters
  Widget _buildConversionInterface({required String type}) {
    // Get the appropriate units for this converter type
    final List<String> units = conversionUnits[type] ?? [];

    return Column(
      children: [
        // Input Card
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Input Value',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _expression.isEmpty ? '0' : _expression,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Unit Selectors
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            children: [
              // From Unit Dropdown
              Flexible(
                flex: 4,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 140),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: fromUnit,
                      dropdownColor: Colors.black87,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                      isExpanded: true,
                      itemHeight: 48,
                      items: units.map((String unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(unit, overflow: TextOverflow.ellipsis),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            fromUnit = newValue;
                            _performConversion();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Swap Button
              SizedBox(
                width: 44,
                height: 44,
                child: Material(
                  color: Colors.amber.shade400,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() {
                        String temp = fromUnit;
                        fromUnit = toUnit;
                        toUnit = temp;
                        _performConversion();
                      });
                    },
                    child: const Icon(Icons.swap_horiz,
                        color: Colors.white, size: 24),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // To Unit Dropdown
              Flexible(
                flex: 4,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 140),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: toUnit,
                      dropdownColor: Colors.black87,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                      isExpanded: true,
                      itemHeight: 48,
                      items: units.map((String unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(unit, overflow: TextOverflow.ellipsis),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            toUnit = newValue;
                            _performConversion();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Result Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade400, Colors.orange.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.shade400.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Result',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  output,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$fromUnit → $toUnit',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Keypad
        Expanded(
          child: _buildConverterKeypad(onKeyTap: (val) {
            setState(() {
              if (val == 'C') {
                _expression = '';
                output = '0';
              } else if (val == 'DEL') {
                if (_expression.isNotEmpty) {
                  _expression =
                      _expression.substring(0, _expression.length - 1);
                }
                if (_expression.isEmpty) output = '0';
              } else {
                if (val == '.' && _expression.contains('.')) return;
                _expression += val;
              }
              _performConversion();
            });
          }),
        ),
      ],
    );
  }

  // Time converter UI
  Widget _buildTimeConverter() {
    final List<String> units = conversionUnits['Time'] ?? [];

    return Column(
      children: [
        // Input Card
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Input Value',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _expression.isEmpty ? '0' : _expression,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Unit Selectors
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            children: [
              // From Unit Dropdown
              Flexible(
                flex: 4,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 140),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: fromUnit,
                      dropdownColor: Colors.black87,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                      isExpanded: true,
                      itemHeight: 48,
                      items: units.map((String unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(unit, overflow: TextOverflow.ellipsis),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            fromUnit = newValue;
                            _performTimeConversion();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Swap Button
              SizedBox(
                width: 44,
                height: 44,
                child: Material(
                  color: Colors.amber.shade400,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() {
                        String temp = fromUnit;
                        fromUnit = toUnit;
                        toUnit = temp;
                        _performTimeConversion();
                      });
                    },
                    child: const Icon(Icons.swap_horiz,
                        color: Colors.white, size: 24),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // To Unit Dropdown
              Flexible(
                flex: 4,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 140),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: toUnit,
                      dropdownColor: Colors.black87,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                      isExpanded: true,
                      itemHeight: 48,
                      items: units.map((String unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(unit, overflow: TextOverflow.ellipsis),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            toUnit = newValue;
                            _performTimeConversion();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Result Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade400.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Result',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  output,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$fromUnit → $toUnit',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Keypad
        Expanded(
          child: _buildConverterKeypad(onKeyTap: (val) {
            setState(() {
              if (val == 'C') {
                _expression = '';
                output = '0';
              } else if (val == 'DEL') {
                if (_expression.isNotEmpty) {
                  _expression =
                      _expression.substring(0, _expression.length - 1);
                }
                if (_expression.isEmpty) output = '0';
              } else {
                if (val == '.' && _expression.contains('.')) return;
                _expression += val;
              }
              _performTimeConversion();
            });
          }),
        ),
      ],
    );
  }

  // BMI calculator UI - Compact and beautiful
  Widget _buildBMICalculator() {
    bool isEnteringWeight = weight == 0 || (weight > 0 && height == 0);
    return Column(
      children: [
        // Input Card (Weight & Height side by side)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
            ),
            child: Row(
              children: [
                // Weight
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _expression = '';
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.monitor_weight,
                                color: Colors.amber.shade400, size: 20),
                            SizedBox(width: 6),
                            Text('Weight (kg)',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 13)),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(weight == 0 ? '0' : weight.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        if (isEnteringWeight && _expression.isNotEmpty)
                          Text('Entering: $_expression',
                              style: TextStyle(
                                  color: Colors.amber.shade400, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                Container(
                    width: 1,
                    height: 48,
                    color: Colors.white.withOpacity(0.08)),
                // Height
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _expression = '';
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.height,
                                color: Colors.blue.shade300, size: 20),
                            SizedBox(width: 6),
                            Text('Height (m)',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 13)),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(height == 0 ? '0' : height.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        if (!isEnteringWeight && _expression.isNotEmpty)
                          Text('Entering: $_expression',
                              style: TextStyle(
                                  color: Colors.blue.shade300, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // BMI Result Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.shade400.withOpacity(0.18),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.white, size: 28),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BMI',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: 2),
                    Text(_formatNumber(bmi),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text(bmiCategory,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Keypad
        Expanded(
          child: _buildConverterKeypad(onKeyTap: (val) {
            setState(() {
              if (val == 'C') {
                _expression = '';
                weight = 0;
                height = 0;
                bmi = 0;
                bmiCategory = '';
                output = '0';
              } else if (val == 'DEL') {
                if (_expression.isNotEmpty) {
                  _expression =
                      _expression.substring(0, _expression.length - 1);
                }
                if (_expression.isEmpty) output = '0';
              } else {
                if (val == '.' && _expression.contains('.')) return;
                _expression += val;
                _calculateBMI();
              }
            });
          }),
        ),
      ],
    );
  }

  // GST calculator UI - Compact and beautiful
  Widget _buildGSTCalculator() {
    return Column(
      children: [
        // Input Card (Base Price & GST % side by side)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
            ),
            child: Row(
              children: [
                // Base Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.attach_money,
                              color: Colors.amber.shade400, size: 20),
                          SizedBox(width: 6),
                          Text('Base Price',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13)),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(basePrice == 0 ? '0' : basePrice.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                    width: 1,
                    height: 48,
                    color: Colors.white.withOpacity(0.08)),
                // GST %
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.percent,
                              color: Colors.blue.shade300, size: 20),
                          SizedBox(width: 6),
                          Text('GST %',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13)),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(gstPercent == 0 ? '0' : gstPercent.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Result Card (GST Amount & Total Price)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.purple.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.shade400.withOpacity(0.18),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.receipt_long, color: Colors.white, size: 28),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('GST Amount',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: 2),
                    Text(_formatNumber(gstAmount),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Total Price',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: 2),
                    Text(_formatNumber(totalPrice),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Keypad
        Expanded(
          child: _buildConverterKeypad(onKeyTap: (val) {
            setState(() {
              if (val == 'C') {
                _expression = '';
                basePrice = 0;
                gstPercent = 18;
                gstAmount = 0;
                totalPrice = 0;
                output = '0';
              } else if (val == 'DEL') {
                if (_expression.isNotEmpty) {
                  _expression =
                      _expression.substring(0, _expression.length - 1);
                }
                if (_expression.isEmpty) output = '0';
              } else {
                if (val == '.' && _expression.contains('.')) return;
                _expression += val;
              }
              _calculateGST(double.tryParse(_expression) ?? 0);
            });
          }),
        ),
      ],
    );
  }
}

// Animated button with shadow and scale effect
class _AnimatedButton extends StatefulWidget {
  final VoidCallback onTap;
  final List<Color> gradientColors;
  final String text;
  final Color textColor;
  final double borderRadius;
  final double minHeight;
  final double fontSize;

  const _AnimatedButton({
    required this.onTap,
    required this.gradientColors,
    required this.text,
    required this.textColor,
    this.borderRadius = 32,
    this.minHeight = 64,
    this.fontSize = 26,
    Key? key,
  }) : super(key: key);

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _scale = 0.94);
      },
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _scale = 1.0);
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: Container(
          constraints: BoxConstraints(minHeight: widget.minHeight),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors.length == 2
                  ? [
                      widget.gradientColors[0],
                      Color.lerp(
                        widget.gradientColors[0],
                        widget.gradientColors[1],
                        0.5,
                      )!,
                      widget.gradientColors[1],
                    ]
                  : widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors[0].withOpacity(0.28),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight:
                    widget.text == '=' ? FontWeight.w700 : FontWeight.w600,
                color: widget.textColor,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(color: Colors.black.withOpacity(0.12), blurRadius: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Animated gradient background widget
class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground({Key? key}) : super(key: key);

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.primaryColor, // Use theme primary color
                theme.primaryColorDark, // Use theme primary dark color
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _ParticlePainter(_controller)),
          ),
        ),
      ],
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final Animation<double> animation;
  _ParticlePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.10);
    final int particleCount = 18;
    final double time = animation.value * 2 * 3.1415;
    for (int i = 0; i < particleCount; i++) {
      final double angle = (i / particleCount) * 2 * 3.1415 + time;
      final double radius = size.shortestSide * 0.38 + 18 * (i % 3);
      final double x = size.width / 2 +
          radius * math.cos(angle + time * (i % 2 == 0 ? 1 : -1));
      final double y = size.height / 2 +
          radius * math.sin(angle + time * (i % 2 == 0 ? 1 : -1));
      canvas.drawCircle(Offset(x, y), 8 + (i % 3) * 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

// Helper widget for birthday info cards
class _BirthdayInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _BirthdayInfoCard(
      {required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber.shade200, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const CalculatorAPP());
}

class CalculatorAPP extends StatelessWidget {
  const CalculatorAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A00FF), // Vibrant purple
          brightness: Brightness.dark,
        ),
      ),
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String output = '0';
  String _output = '0'; //internal output
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
      'USD to EUR': 0.858,
      'EUR to USD': 1.166,
      'USD to GBP': 0.732,
      'GBP to USD': 1.366,
      'USD to JPY': 145.28,
      'JPY to USD': 0.00688,
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
    'Mass': ['Kilograms', 'Pounds', 'Grams', 'Ounces'],
    'Currency': ['USD', 'EUR', 'GBP', 'JPY', 'INR', 'AED', 'SAR', 'SGD'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Area': [
      'Square Meters',
      'Square Feet',
      'Square Kilometers',
      'Square Miles',
      'Acres',
      'Hectares',
    ],
    'Time': ['Seconds', 'Minutes', 'Hours', 'Days', 'Weeks', 'Years'],
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
    'Speed': ['Meters/second', 'Kilometers/hour', 'Miles/hour', 'Knots'],
  };

  // Add this helper to the _CalculatorScreenState class:
  String _formatNumber(num value) {
    if (value.isNaN || value.isInfinite) return 'Invalid';
    if (value.abs() >= 1e9 || (value.abs() < 1e-6 && value != 0)) {
      return value.toStringAsExponential(4);
    }
    if (value % 1 == 0) {
      return NumberFormat.decimalPattern().format(value);
    }
    // For decimals, show up to 6 decimals, remove trailing zeros
    String formatted = value.toStringAsFixed(6);
    formatted = formatted.replaceAll(
      RegExp(r'(\.\d*?)0+'),
      r'\1',
    ); // Remove trailing zeros after decimal
    formatted = formatted.replaceAll(RegExp(r'\.0+'), ''); // Remove .0000
    if (formatted.endsWith('.'))
      formatted = formatted.substring(0, formatted.length - 1);
    return NumberFormat.decimalPattern().format(double.parse(formatted));
  }

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
                        isConversionMode
                            ? "Calculator"
                            : isScientificMode
                            ? "Calculator"
                            : "Calculator",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const Spacer(),
                      // Top navigation icons
                      _buildTopNavIcon(Icons.history, () {
                        // Show history
                        _showHistoryDialog();
                      }),
                      _buildTopNavIcon(Icons.science, () {
                        setState(() {
                          isScientificMode = !isScientificMode;
                          isConversionMode = false;
                        });
                      }, isActive: isScientificMode),
                      _buildTopNavIcon(Icons.swap_horiz, () {
                        // Toggle between units
                        if (isConversionMode) {
                          final temp = fromUnit;
                          setState(() {
                            fromUnit = toUnit;
                            toUnit = temp;
                            _performConversion();
                          });
                        }
                      }),
                      _buildTopNavIcon(Icons.science_outlined, () {
                        // Toggle conversion mode
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
                      _buildTopNavIcon(Icons.grid_view, () {
                        // Show more options
                      }),
                    ],
                  ),
                ),

                // Converter category bar (only visible in conversion mode)
                if (isConversionMode) ...[
                  const SizedBox(height: 8),
                  buildEssentialCategoryToggleBar(),
                  const SizedBox(height: 12),
                ],

                // Main content
                if (isConversionMode)
                  Expanded(child: _buildSelectedConverter())
                else
                  Expanded(
                    child: Column(
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
                selectedCategoryIndex = index;
                selectedConversionType = category['label'];
                if (conversionUnits.containsKey(category['label'])) {
                  List<String> units = conversionUnits[category['label']]!;
                  if (units.isNotEmpty) {
                    fromUnit = units[0];
                    toUnit = units.length > 1 ? units[1] : units[0];
                  }
                }
                _output = '0';
                output = '0';
                _performConversion();
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
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
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
    final List<Map<String, dynamic>> buttons = [
      {'text': 'C', 'color': Colors.red.shade400},
      {'text': 'DEL', 'color': Colors.red.shade400},
      {'text': '/', 'color': Colors.amber.shade400},
      {'text': '7', 'color': Colors.deepPurple.shade400},
      {'text': '8', 'color': Colors.blue.shade400},
      {'text': '9', 'color': Colors.teal.shade400},
      {'text': '*', 'color': Colors.amber.shade400},
      {'text': '4', 'color': Colors.green.shade400},
      {'text': '5', 'color': Colors.indigo.shade400},
      {'text': '6', 'color': Colors.pink.shade400},
      {'text': '-', 'color': Colors.amber.shade400},
      {'text': '1', 'color': Colors.deepOrange.shade400},
      {'text': '2', 'color': Colors.lightGreen.shade400},
      {'text': '3', 'color': Colors.cyan.shade400},
      {'text': '+', 'color': Colors.amber.shade400},
      {'text': '.', 'color': Colors.grey.shade700},
      {'text': '0', 'color': Colors.amber.shade300},
      {'text': '=', 'color': Colors.deepPurple.shade500},
    ];

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        return _buildColorfulButton(
          buttons[index]['text'],
          buttons[index]['color'],
        );
      },
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
    if (button == 'C') {
      _clear();
    } else if (button == 'DEL') {
      _delete();
    } else if (button == '=') {
      _calculate();
    } else {
      _append(button);
    }
  }

  void _clear() {
    output = '0';
    _output = '0';
    expression = '';
  }

  void _delete() {
    if (output.length > 1) {
      output = output.substring(0, output.length - 1);
    } else {
      output = '0';
    }
  }

  void _calculate() {
    if (expression.isNotEmpty) {
      try {
        num2 = double.parse(output);
        if (operand.isNotEmpty) {
          num1 = double.parse(expression.split(operand)[0]);
          switch (operand) {
            case '+':
              output = (num1 + num2).toString();
              break;
            case '-':
              output = (num1 - num2).toString();
              break;
            case '*':
              output = (num1 * num2).toString();
              break;
            case '/':
              output = (num1 / num2).toString();
              break;
          }
          expression = '';
        }
      } catch (e) {
        output = 'Error';
      }
    }
  }

  void _append(String button) {
    if (output == '0') {
      output = button;
    } else {
      output += button;
    }
  }

  Widget _buildScientificKeypad() {
    final List<Map<String, dynamic>> buttons = [
      {'text': 'sin', 'color': Colors.blueGrey.shade400},
      {'text': 'cos', 'color': Colors.blueGrey.shade400},
      {'text': 'tan', 'color': Colors.blueGrey.shade400},
      {'text': 'π', 'color': Colors.purple.shade400},
      {'text': 'e', 'color': Colors.purple.shade400},
      {'text': 'x²', 'color': Colors.teal.shade400},
      {'text': '√', 'color': Colors.teal.shade400},
      {'text': 'ln', 'color': Colors.blueGrey.shade400},
      {'text': 'log', 'color': Colors.blueGrey.shade400},
      {'text': '10^x', 'color': Colors.teal.shade400},
      {'text': 'e^x', 'color': Colors.teal.shade400},
      {'text': 'x!', 'color': Colors.purple.shade400},
      {'text': 'C', 'color': Colors.red.shade400},
      {'text': 'DEL', 'color': Colors.red.shade400},
      {'text': '=', 'color': Colors.deepPurple.shade500},
    ];

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.0,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        return _buildScientificColorfulButton(
          buttons[index]['text'],
          buttons[index]['color'],
        );
      },
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
    if (button == 'sin') {
      output = math.sin(double.parse(output) * math.pi / 180).toString();
    } else if (button == 'cos') {
      output = math.cos(double.parse(output) * math.pi / 180).toString();
    } else if (button == 'tan') {
      output = math.tan(double.parse(output) * math.pi / 180).toString();
    } else if (button == 'π') {
      output = math.pi.toString();
    } else if (button == 'e') {
      output = math.e.toString();
    } else if (button == 'x²') {
      output = (double.parse(output) * double.parse(output)).toString();
    } else if (button == '√') {
      output = math.sqrt(double.parse(output)).toString();
    } else if (button == 'ln') {
      output = math.log(double.parse(output)).toString();
    } else if (button == 'log') {
      output = (math.log(double.parse(output)) / math.ln10).toString();
    } else if (button == '10^x') {
      output = (math.pow(10, double.parse(output))).toString();
    } else if (button == 'e^x') {
      output = math.exp(double.parse(output)).toString();
    } else if (button == 'x!') {
      output = _factorial(int.parse(output)).toString();
    } else if (button == 'C') {
      _clear();
    } else if (button == 'DEL') {
      _delete();
    } else if (button == '=') {
      _calculate();
    }
  }

  double _factorial(int n) {
    if (n <= 1) return 1;
    double result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  Widget _buildSelectedConverter() {
    final label = essentialCategories[selectedCategoryIndex]['label'];

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
      default:
        return _buildConversionInterface(type: label);
    }
  }

  void _performConversion() {
    if (_output == '0' || _output.isEmpty) return;
    try {
      double inputValue = double.parse(_output);
      double result = 0;
      String convType = selectedConversionType;
      String from = fromUnit;
      String to = toUnit;
      // Handle temperature conversions (special cases)
      if (convType == 'Temperature') {
        if (from == to) {
          result = inputValue;
        } else if (from == 'Celsius' && to == 'Fahrenheit') {
          result = inputValue * 9 / 5 + 32;
        } else if (from == 'Fahrenheit' && to == 'Celsius') {
          result = (inputValue - 32) * 5 / 9;
        } else if (from == 'Celsius' && to == 'Kelvin') {
          result = inputValue + 273.15;
        } else if (from == 'Kelvin' && to == 'Celsius') {
          result = inputValue - 273.15;
        } else if (from == 'Fahrenheit' && to == 'Kelvin') {
          result = (inputValue - 32) * 5 / 9 + 273.15;
        } else if (from == 'Kelvin' && to == 'Fahrenheit') {
          result = (inputValue - 273.15) * 9 / 5 + 32;
        }
      } else {
        String conversionKey = '$from to $to';
        if (conversionRates[convType] != null &&
            conversionRates[convType]!.containsKey(conversionKey)) {
          result = inputValue * conversionRates[convType]![conversionKey]!;
        } else {
          // Try reverse conversion
          String reverseKey = '$to to $from';
          if (conversionRates[convType] != null &&
              conversionRates[convType]!.containsKey(reverseKey)) {
            result = inputValue / conversionRates[convType]![reverseKey]!;
          } else {
            result = inputValue;
          }
        }
      }
      setState(() {
        output = _formatNumber(result);
      });
      calculationHistory.add('$inputValue $from = $output $to');
    } catch (e) {
      setState(() {
        output = 'Error';
      });
    }
  }

  Widget _buildConversionInterface({String? type}) {
    final colorScheme = Theme.of(context).colorScheme;
    final String convType = type ?? selectedConversionType;
    final units = conversionUnits[convType] ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Unit selectors
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: fromUnit,
                      items: units
                          .map(
                            (u) => DropdownMenuItem(value: u, child: Text(u)),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          fromUnit = val!;
                          _performConversion();
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.swap_horiz, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: toUnit,
                      items: units
                          .map(
                            (u) => DropdownMenuItem(value: u, child: Text(u)),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          toUnit = val!;
                          _performConversion();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Input field
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Enter value',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
            ),
            onChanged: (val) {
              setState(() {
                _output = val;
                _performConversion();
              });
            },
          ),
          const SizedBox(height: 24),
          // Result
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '$output $toUnit',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHistoryDialog() {
    // Implementation of _showHistoryDialog method
    // This method should show the history dialog
    throw UnimplementedError();
  }

  void _showBirthdayCalculator() {
    // Implementation of _showBirthdayCalculator method
    // This method should show the birthday calculator
    throw UnimplementedError();
  }

  Widget _buildDiscountCalculator() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Original Price',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
            ),
            onChanged: (val) {
              setState(() {
                originalPrice = double.tryParse(val) ?? 0;
                if (discountPercent > 0) {
                  savedAmount = originalPrice * (discountPercent / 100);
                  finalPrice = originalPrice - savedAmount;
                }
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Discount %',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
            ),
            onChanged: (val) {
              setState(() {
                discountPercent = double.tryParse(val) ?? 0;
                if (originalPrice > 0) {
                  savedAmount = originalPrice * (discountPercent / 100);
                  finalPrice = originalPrice - savedAmount;
                }
              });
            },
          ),
          const SizedBox(height: 24),
          if (finalPrice > 0) ...[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Final Price: \$${_formatNumber(finalPrice)}',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You Save: \$${_formatNumber(savedAmount)}',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateCalculator() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() {
                    startDate = date;
                    if (endDate != null) {
                      daysDifference = endDate!.difference(startDate!).inDays;
                    }
                  });
                }
              },
              child: Text(
                'Select Start Date: ${startDate?.toString().split(' ')[0] ?? 'Not selected'}',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: endDate ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() {
                    endDate = date;
                    if (startDate != null) {
                      daysDifference = endDate!.difference(startDate!).inDays;
                    }
                  });
                }
              },
              child: Text(
                'Select End Date: ${endDate?.toString().split(' ')[0] ?? 'Not selected'}',
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (daysDifference != 0)
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'Days Difference: $daysDifference',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNumeralSystemConverter() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter Decimal Number',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
            ),
            onChanged: (val) {
              setState(() {
                decimalValue = val;
                convertNumber(val);
              });
            },
          ),
          const SizedBox(height: 24),
          if (binaryValue.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Binary: $binaryValue',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Octal: $octalValue',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hex: $hexValue',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void convertNumber(String value) {
    try {
      int decimal = int.parse(value);
      setState(() {
        decimalValue = decimal.toString();
        binaryValue = decimal.toRadixString(2);
        octalValue = decimal.toRadixString(8);
        hexValue = decimal.toRadixString(16).toUpperCase();
      });
    } catch (e) {
      // Handle invalid input
    }
  }

  Widget _buildBMICalculator() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
            ),
            onChanged: (val) {
              setState(() {
                weight = double.tryParse(val) ?? 0;
                calculateBMI();
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Height (m)',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
            ),
            onChanged: (val) {
              setState(() {
                height = double.tryParse(val) ?? 0;
                calculateBMI();
              });
            },
          ),
          const SizedBox(height: 24),
          if (bmi > 0) ...[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'BMI: ${_formatNumber(bmi)}',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: $bmiCategory',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void calculateBMI() {
    if (weight > 0 && height > 0) {
      bmi = weight / (height * height);
      if (bmi < 18.5)
        bmiCategory = 'Underweight';
      else if (bmi < 25)
        bmiCategory = 'Normal weight';
      else if (bmi < 30)
        bmiCategory = 'Overweight';
      else
        bmiCategory = 'Obese';
    }
  }

  Widget _buildGSTCalculator() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Base Price',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
            ),
            onChanged: (val) {
              setState(() {
                basePrice = double.tryParse(val) ?? 0;
                calculateGST();
              });
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: DropdownButton<double>(
              isExpanded: true,
              dropdownColor: Colors.black87,
              value: gstPercent,
              items: [5.0, 12.0, 18.0, 28.0]
                  .map(
                    (rate) => DropdownMenuItem(
                      value: rate,
                      child: Text('GST Rate: $rate%'),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  gstPercent = val!;
                  calculateGST();
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          if (totalPrice > 0) ...[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'GST Amount: \$${_formatNumber(gstAmount)}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Price: \$${_formatNumber(totalPrice)}',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void calculateGST() {
    gstAmount = basePrice * (gstPercent / 100);
    totalPrice = basePrice + gstAmount;
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
                fontWeight: widget.text == '='
                    ? FontWeight.w700
                    : FontWeight.w600,
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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF00BCD4), // Turquoise top
                Color(0xFF0288D1), // Blue bottom
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
      final double x =
          size.width / 2 +
          radius * math.cos(angle + time * (i % 2 == 0 ? 1 : -1));
      final double y =
          size.height / 2 +
          radius * math.sin(angle + time * (i % 2 == 0 ? 1 : -1));
      canvas.drawCircle(Offset(x, y), 8 + (i % 3) * 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

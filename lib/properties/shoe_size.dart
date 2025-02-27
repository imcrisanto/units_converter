import 'package:units_converter/models/node.dart';
import 'package:units_converter/models/property.dart';
import 'package:units_converter/models/unit.dart';
import 'package:units_converter/utils/utils.dart';

//Available SHOE_SIZE units
enum SHOE_SIZE {
  centimeters,
  inches,
  euChina,
  ukIndiaChild,
  ukIndiaMan,
  ukIndiaWoman,
  usaCanadaChild,
  usaCanadaMan,
  usaCanadaWoman,
  japan,
}

class ShoeSize extends Property<SHOE_SIZE, double> {
  //Map between units and its symbol
  final Map<SHOE_SIZE, String> mapSymbols = {
    SHOE_SIZE.centimeters: 'cm',
    SHOE_SIZE.inches: 'in',
  };

  int significantFigures;
  bool removeTrailingZeros;

  ///Class for ShoeSize conversions, e.g. if you want to convert 1 centimeter in eu shoes size:
  ///```dart
  ///var ShoeSize = ShoeSize(removeTrailingZeros: false);
  ///ShoeSize.convert(Unit(SHOE_SIZE.centimeters, value: 1));
  ///print(SHOE_SIZE.eu_china);
  /// ```
  ShoeSize(
      {this.significantFigures = 10, this.removeTrailingZeros = true, name}) {
    size = SHOE_SIZE.values.length;
    this.name = name ?? PROPERTY.shoeSize;
    for (SHOE_SIZE val in SHOE_SIZE.values) {
      unitList.add(Unit(val, symbol: mapSymbols[val]));
    }
    unitConversion = Node(name: SHOE_SIZE.centimeters, leafNodes: [
      Node(
        coefficientProduct: 1 / 1.5,
        coefficientSum: -1.5,
        name: SHOE_SIZE.euChina,
      ),
      Node(coefficientProduct: 2.54, name: SHOE_SIZE.inches, leafNodes: [
        Node(
          coefficientProduct: 1 / 3,
          coefficientSum: 10 / 3,
          name: SHOE_SIZE.ukIndiaChild,
        ),
        Node(
          coefficientProduct: 1 / 3,
          coefficientSum: 23 / 3,
          name: SHOE_SIZE.ukIndiaMan,
        ),
        Node(
          coefficientProduct: 1 / 3,
          coefficientSum: 23.5 / 3,
          name: SHOE_SIZE.ukIndiaWoman,
        ),
        Node(
          coefficientProduct: 1 / 3,
          coefficientSum: 49 / 9,
          name: SHOE_SIZE.usaCanadaChild,
        ),
        Node(
          coefficientProduct: 1 / 3,
          coefficientSum: 22 / 3,
          name: SHOE_SIZE.usaCanadaMan,
        ),
        Node(
          coefficientProduct: 1 / 3,
          coefficientSum: 21 / 3,
          name: SHOE_SIZE.usaCanadaWoman,
        ),
      ]),
      Node(
        coefficientSum: -1.5,
        name: SHOE_SIZE.japan,
      ),
    ]);
    nodeList = unitConversion.getTreeAsList();
  }

  ///Converts a unit with a specific name (e.g. SHOE_SIZE.uk_india_woman) and value to all other units
  @override
  void convert(SHOE_SIZE name, double? value) {
    super.convert(name, value);
    if (value == null) return;
    for (var i = 0; i < SHOE_SIZE.values.length; i++) {
      unitList[i].value = getNodeByName(SHOE_SIZE.values.elementAt(i)).value;
      unitList[i].stringValue = mantissaCorrection(
          unitList[i].value!, significantFigures, removeTrailingZeros);
    }
  }

  Unit get centimeters => getUnit(SHOE_SIZE.centimeters);
  Unit get inches => getUnit(SHOE_SIZE.inches);
  Unit get euChina => getUnit(SHOE_SIZE.euChina);
  Unit get ukIndiaChild => getUnit(SHOE_SIZE.ukIndiaChild);
  Unit get ukIndiaMan => getUnit(SHOE_SIZE.ukIndiaMan);
  Unit get ukIndiaWoman => getUnit(SHOE_SIZE.ukIndiaWoman);
  Unit get usaCanadaChild => getUnit(SHOE_SIZE.usaCanadaChild);
  Unit get usaCanadaMan => getUnit(SHOE_SIZE.usaCanadaMan);
  Unit get usaCanadaWoman => getUnit(SHOE_SIZE.usaCanadaWoman);
  Unit get japan => getUnit(SHOE_SIZE.japan);
}

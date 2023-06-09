import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DataService{
  final ValueNotifier<Map> tableStateNotifier = ValueNotifier({"jsonObjects" : [], "propertyNames" : [""], "collumnNames" : [""]});

  void carregar(index){
    List<Function> loads = [carregarCafes, carregarCervejas, carregarNacoes];
    loads[index]();
  }

  void carregarCafes(){
    tableStateNotifier.value = {
      "jsonObjects" : [
        {
          "brand": "Nescafé",
          "style": "Expresso",
          "price": "R\$3.00"
        },
        {
          "brand": "Pilão",
          "style": "Com leite",
          "price": "R\$2.00"
        },
        {
          "brand": "Melitta", 
          "style": "Sem açúcar", 
          "price": "R\$2.50"
        }
      ],
      "propertyNames" : ["brand", "style", "price"],
      "collumnNames" : ["Marca", "Estilo", "Preço"]
    };
  }

  void carregarCervejas(){
    tableStateNotifier.value = {
      "jsonObjects": [
        {
          "name": "La Fin Du Monde",
          "style": "Bock",
          "ibu": "65"
        },
        {
          "name": "Sapporo Premiume",
          "style": "Sour Ale",
          "ibu": "54"
        },
        {
          "name": "Duvel", 
          "style": "Pilsner", 
          "ibu": "82"
        }
      ], 
      "propertyNames" : ["name","style","ibu"], 
      "collumnNames" : ["Nome", "Estilo", "IBU"] 
    };
  }

  void carregarNacoes(){
    tableStateNotifier.value = {
      "jsonObjects" : [
        {
          "name": "Brasil",
          "language": "Português",
          "currency": "Real"
        },
        {
          "name": "Argentina",
          "language": "Espanhol",
          "currency": "Peso argentino"
        },
        {
          "name": "EUA", 
          "language": "Inglês", 
          "currency": "Dólar"
        }
      ],
      "propertyNames" : ["name", "language", "currency"],
      "collumnNames" : ["Nome", "Idioma", "Moeda"]
    };
  }
}

final dataService = DataService();

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner:false,
      home: Scaffold(
        appBar: AppBar( 
          title: const Text("Dicas"),
        ),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder:(_, value, __){
            return DataTableWidget(
              jsonObjects: value["jsonObjects"], 
              propertyNames: value["propertyNames"], 
              columnNames: value["collumnNames"]
            );
          }
        ),
        bottomNavigationBar: NewNavBar(itemSelectedCallback: dataService.carregar),
      )
    );
  }
}

class NewNavBar extends HookWidget {
  var itemSelectedCallback;

  NewNavBar({this.itemSelectedCallback}){
    itemSelectedCallback ??= (_){} ;
  } 

  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    return BottomNavigationBar(
      onTap: (index){
        state.value = index;
        itemSelectedCallback(index);                
      }, 
      currentIndex: state.value,
      items: const [
        BottomNavigationBarItem(
          label: "Cafés",
          icon: Icon(Icons.coffee_outlined),
        ),
        BottomNavigationBarItem(
          label: "Cervejas", 
          icon: Icon(Icons.local_drink_outlined)
        ),
        BottomNavigationBarItem(
          label: "Nações", 
          icon: Icon(Icons.flag_outlined)
        )
      ]
    );
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget( {this.jsonObjects = const [], this.columnNames = const ["Nome","Estilo","IBU"], this.propertyNames= const ["name", "style", "ibu"]});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: columnNames.map( 
        (name) => DataColumn(
          label: Expanded(
            child: Text(name, style: TextStyle(fontStyle: FontStyle.italic))
          )
        )
      ).toList(),
      rows: jsonObjects.map( 
        (obj) => DataRow(
          cells: propertyNames.map(
            (propName) => DataCell(Text(obj[propName]))
          ).toList()
        )
      ).toList()
    );
  }
}
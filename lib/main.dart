import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liste de Courses',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoppingListScreen(),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingItem> shoppingItems = [];

  // Controller pour les champs du formulaire
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  // Déclaration d'une clé pour le formulaire
  final _formKey = GlobalKey<FormState>();

  // Variable pour le tri
  bool _sortByName = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de Courses'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: shoppingItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(shoppingItems[index].name),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: AlignmentDirectional.centerEnd,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    // Supprime l'article lorsqu'on fait glisser à gauche
                    _removeItem(index);
                  },
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(shoppingItems[index].name),
                      subtitle: Text(
                        'Catégorie: ${shoppingItems[index].category}, Quantité: ${shoppingItems[index].quantity}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: shoppingItems[index].isBought,
                            onChanged: (value) {
                              // Marque ou démarque l'article comme acheté
                              _toggleBoughtStatus(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Affiche le formulaire de modification lorsqu'on clique sur le bouton
                              _showEditItemDialog(context, index);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Ajoutez ici la logique pour modifier un élément
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Affiche le formulaire d'ajout lorsqu'on clique sur le bouton
                _showAddItemDialog(context);
              },
              child: Text('Ajouter un article'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Trie la liste par nom
                  setState(() {
                    _sortByName = true;
                    shoppingItems.sort((a, b) => a.name.compareTo(b.name));
                  });
                },
                child: Text('Trier par nom'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Trie la liste par catégorie
                  setState(() {
                    _sortByName = false;
                    shoppingItems.sort((a, b) => a.category.compareTo(b.category));
                  });
                },
                child: Text('Trier par catégorie'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Fonction pour afficher le formulaire dans une boîte de dialogue
  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un article'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom de l\'article';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Nom de l\'article'),
                ),
                TextFormField(
                  controller: categoryController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer la catégorie de l\'article';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Catégorie'),
                ),
                TextFormField(
                  controller: quantityController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer la quantité de l\'article';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Quantité'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Ajoutez ici la logique pour ajouter un élément
                if (_formKey.currentState?.validate() ?? false) {
                  _addItem();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher le formulaire de modification dans une boîte de dialogue
  void _showEditItemDialog(BuildContext context, int index) {
    nameController.text = shoppingItems[index].name;
    categoryController.text = shoppingItems[index].category;
    quantityController.text = shoppingItems[index].quantity.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier l\'article'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom de l\'article';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Nom de l\'article'),
                ),
                TextFormField(
                  controller: categoryController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer la catégorie de l\'article';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Catégorie'),
                ),
                TextFormField(
                  controller: quantityController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer la quantité de l\'article';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Quantité'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Ajoutez ici la logique pour modifier l'élément
                if (_formKey.currentState?.validate() ?? false) {
                  _editItem(index);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour ajouter un article à la liste
  void _addItem() {
    setState(() {
      ShoppingItem newItem = ShoppingItem(
        name: nameController.text,
        category: categoryController.text,
        quantity: int.tryParse(quantityController.text) ?? 0,
      );

      shoppingItems.add(newItem);

      // Efface les contrôleurs après avoir ajouté un élément
      nameController.clear();
      categoryController.clear();
      quantityController.clear();
    });
  }

  // Fonction pour modifier un article dans la liste
  void _editItem(int index) {
    setState(() {
      shoppingItems[index].name = nameController.text;
      shoppingItems[index].category = categoryController.text;
      shoppingItems[index].quantity = int.tryParse(quantityController.text) ?? 0;

      // Efface les contrôleurs après avoir modifié un élément
      nameController.clear();
      categoryController.clear();
      quantityController.clear();
    });
  }

  // Fonction pour supprimer un article de la liste
  void _removeItem(int index) {
    setState(() {
      shoppingItems.removeAt(index);
    });
  }

  // Fonction pour marquer ou démarquer un article comme acheté
  void _toggleBoughtStatus(int index) {
    setState(() {
      shoppingItems[index].isBought = !shoppingItems[index].isBought;
    });
  }
}

class ShoppingItem {
  String name;
  String category;
  int quantity;
  bool isBought;

  ShoppingItem({
    required this.name,
    required this.category,
    required this.quantity,
    this.isBought = false,
  });
}

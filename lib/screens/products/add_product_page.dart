import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();
  String? _imageUrl;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedCategory;
  String? _selectedBrand;
  String _condition = 'Yeni/Etiketli';

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<String?> uploadImageToImgbb(File image) async {
    final apiKey = '00240c96dc792a86514ae99d30845c83'; // imgbb.com'dan aldığın anahtar
    final url = Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey");
    final base64Image = base64Encode(image.readAsBytesSync());
    final response = await http.post(url, body: {'image': base64Image});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']['url'];
    } else {
      print("Resim yükleme hatası: ${response.body}");
      return null;
    }
  }

  void uploadProduct() async {
    if (!_formKey.currentState!.validate() || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen tüm alanları doldurun ve resim seçin")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Ürün yükleniyor...")),
    );

    final imageUrl = await uploadImageToImgbb(_image!);
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resim yüklenemedi')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('products').add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'category': _selectedCategory,
      'brand': _selectedBrand,
      'condition': _condition,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ürün başarıyla yüklendi.')),
    );

    _formKey.currentState!.reset();
    setState(() => _image = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ürün Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: _image == null
                        ? Icon(Icons.add_a_photo, size: 150)
                        : Image.file(_image!, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: "Başlık"),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Zorunlu alan' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Açıklama"),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Zorunlu alan' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory != null &&
                      ['Elektronik', 'Giyim', 'Kitap'].contains(_selectedCategory)
                      ? _selectedCategory
                      : null,
                  hint: Text("Kategori seç"),
                  items: ['Elektronik', 'Giyim', 'Kitap']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value),
                  validator: (value) => value == null ? 'Kategori seçin' : null,
                ),

                DropdownButtonFormField<String>(
                  value: _selectedBrand != null &&
                      ['Marka A', 'Marka B', 'Marka C'].contains(_selectedBrand)
                      ? _selectedBrand
                      : null,
                  hint: Text("Marka seç"),
                  items: ['Marka A', 'Marka B', 'Marka C']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedBrand = value),
                  validator: (value) => value == null ? 'Marka seçin' : null,
                ),

                Column(
                  children: ['Yeni/Etiketli', 'Kullanılmış', 'Az Kullanılmış'].map((c) => RadioListTile(
                    title: Text(c),
                    value: c,
                    groupValue: _condition,
                    onChanged: (val) => setState(() => _condition = val.toString()),
                  )).toList(),
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: "Fiyat"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Fiyat girin' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: uploadProduct,
                  child: Text("Ürün Ekle"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

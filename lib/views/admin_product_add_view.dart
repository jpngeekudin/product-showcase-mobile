import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:product_showcase/helpers/dio_helper.dart';
import 'package:product_showcase/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_showcase/models/product_model.dart';

class AdminProductAddView extends StatefulWidget {
  const AdminProductAddView({super.key});

  @override
  State<AdminProductAddView> createState() => _AdminProductAddViewState();
}

class _AdminProductAddViewState extends State<AdminProductAddView> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  final _stockController = TextEditingController(text: '0');
  String _category = 'fashion';
  bool _status = true;

  void _initEditedForm() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print(args['edited']);
    if (args['edited'] != null) {
      final edited = args['edited'] as ProductModel;
      _nameController.text = edited.name;
      _descriptionController.text = edited.description;
      _priceController.text = edited.price.toString();
      _stockController.text = edited.stock.toString();
      setState(() {
        _category = edited.category;
      });

      try {
        final directory = await getTemporaryDirectory();
        final filePath =
            '${directory.path}/${edited.image.split('/').last.split('\\').last}';
        await dio.download('/files/get?path=${edited.image}', filePath);
        setState(() {
          _imageFile = XFile(filePath);
        });
      } catch (err) {
        print(err);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed getting image data')));
      }
    }
  }

  void _submit() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please insert image!')));
      return;
    }

    try {
      final imageFormData = FormData.fromMap({
        'file': await MultipartFile.fromFile(_imageFile!.path,
            filename: _imageFile!.name)
      });
      final imageResponse = await dio.post('/files/upload?type=product_image',
          data: imageFormData);
      final response = await dio.post('/products', data: {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': int.parse(_priceController.text),
        'stock': int.parse(_stockController.text),
        'category': _category,
        'image': imageResponse.data['data']
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Success saving product')));
        Navigator.of(context).pop({'status': true});
      }
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed saving product')));
    }
  }

  @override
  void initState() {
    super.initState();
    // _initEditedForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Produk')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(color: AppColors.neutral, height: 8),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambah Produk',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Masukkan detail produk untuk menambahkannya ke inventaris.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _imageFile != null
                        ? Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                          )
                        : Container(
                            color: AppColors.neutral,
                            height: 200,
                            child: Center(
                              child: Icon(
                                Icons.image,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () async {
                        final pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        setState(() {
                          _imageFile = pickedFile;
                        });
                      },
                      child: Text('Upload Gambar'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Nama Produk',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama produk',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Kategori Produk',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Pilih kategori produk',
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'fashion',
                        child: Text('Fashion'),
                      ),
                      DropdownMenuItem(
                        value: 'furniture',
                        child: Text('Furniture'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          _category = value;
                        }
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Deskripsi Produk',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    maxLines: 2,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan deskripsi produk',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Harga Satuan',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      hintText: 'Masukkan harga satuan',
                      prefixIcon: SizedBox(
                        width: 20,
                        child: Center(
                          child: Text(
                            'Rp.',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Stok Awal',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _stockController,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                            hintText: 'Masukkan Stok Awal',
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(hintText: 'Unit'),
                          items: [
                            DropdownMenuItem(
                              value: 'unit',
                              child: Text('Unit'),
                            ),
                          ],
                          onChanged: (value) {
                            // Handle selection
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Produk',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sistem akan menandai produk sebagai “Menipis” secara otomatis jika stoknya mendekati habis.',
                          style: TextStyle(
                            color: Color(0xFF5D6471),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Nonaktif'),
                            SizedBox(width: 8),
                            Switch(
                                value: _status,
                                onChanged: (value) {
                                  setState(() {
                                    _status = value;
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              foregroundColor: Theme.of(context).primaryColor,
                              side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text('Batal'),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _submit();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Simpan'),
                                SizedBox(width: 8),
                                Icon(Icons.check),
                              ],
                            ),
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
      ),
    );
  }
}

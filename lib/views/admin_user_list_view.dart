import 'package:flutter/material.dart';
import 'package:product_showcase/helpers/dio_helper.dart';
import 'package:product_showcase/helpers/http_helper.dart';
import 'package:product_showcase/main.dart';
import 'package:product_showcase/models/user_model.dart';

class AdminUserListView extends StatefulWidget {
  const AdminUserListView({super.key});

  @override
  State<AdminUserListView> createState() => _AdminUserListViewState();
}

class _AdminUserListViewState extends State<AdminUserListView> {
  List<UserModel> _users = [];

  void _getUsers() async {
    try {
      final response = await dio.get('/user');
      setState(() {
        _users = response.data['data']
            .map<UserModel>((e) => UserModel.fromJson(e))
            .toList();
      });
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed getting data')));
    }
  }

  void _deleteUser(UserModel user) async {
    try {
      final response = await dio.delete('/user/products/${user.id}');
      _getUsers();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Success deleting user')));
      }
    } catch (err) {
      print(err);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed deleting user')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 120,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Management User'),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Search',
                  onPressed: () {
                    // handle more actions
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(999),
                        color: Colors.white,
                      ),
                      child: DropdownButton<String>(
                        hint: const Text('Status'),
                        isDense: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        borderRadius: BorderRadius.circular(16),
                        items: <String>['Active', 'Inactive']
                            .map(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Dipilih: $value')),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButtonHideUnderline(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(999),
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      hint: const Text('Sort'),
                      isDense: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      borderRadius: BorderRadius.circular(16),
                      items: <String>['Asc', 'Desc']
                          .map(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Dipilih: $value')),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Item",
        onPressed: () async {
          final result = await Navigator.of(context)
              .pushNamed('/admin/user/add') as Map<String, dynamic>;
          if (result['status']) {
            _getUsers();
          }
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8,
              color: AppColors.neutral,
            ),
            ListView.separated(
                itemCount: _users.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return Divider(
                    color: AppColors.border,
                    height: 0,
                  );
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: Colors.white,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _users[index].fullname,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 14,
                        )
                      ],
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _users[index].phone,
                          style:
                              TextStyle(color: Color(0xFF5B5D63), fontSize: 11),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          _users[index].email,
                          style:
                              TextStyle(color: Color(0xFF5B5D63), fontSize: 11),
                        ),
                      ],
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(8),
                      child: Image.network(
                        '$apiBaseUrl/files/get?path=${_users[index].image}',
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            height: 40,
                            width: 40,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 40,
                          width: 40,
                          color: Colors.grey,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(value: 'delete', child: Text('Delete'))
                        ];
                      },
                      onSelected: (value) {
                        if (value == 'delete') {
                          _deleteUser(_users[index]);
                        }
                      },
                      child: Icon(Icons.more_horiz),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

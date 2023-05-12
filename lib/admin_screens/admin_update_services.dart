// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wash_mesh/models/admin_models/vendor_applied.dart';
import 'package:wash_mesh/providers/admin_provider/admin_auth_provider.dart';
// import 'package:wash_mesh/models/user_models/wash_categories_model.dart' as wc;
// import 'package:wash_mesh/providers/admin_provider/admin_auth_provider.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_button.dart';
import 'package:wash_mesh/widgets/custom_colors.dart';

// import 'package:wash_mesh/widgets/custom_multiselect.dart';

import '../providers/user_provider/user_auth_provider.dart';
import '../widgets/custom_logo.dart';

class AdminUpdateServices extends StatefulWidget {
  const AdminUpdateServices({Key? key}) : super(key: key);

  @override
  State<AdminUpdateServices> createState() => _AdminUpdateServicesState();
}

class _AdminUpdateServicesState extends State<AdminUpdateServices> {
  final List<String> _selectedWashItems = [];
  final List<int> _selectedwashcat = [];
  final List<String> _selectedMeshItems = [];
  final List<int> _selectedmeshcat = [];
  nameid dt = nameid();

  // void _showWashCategory(snapshot) async {
  //   final List<String>? results = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CustomMultiSelect(items: snapshot);
  //     },
  //   );

  //   if (results != null) {
  //     setState(() {
  //       _selectedWashItems = results;
  //     });
  //   }
  // }

  void _washItemChange(String itemValue, bool isSelected, nameid i) {
    if (isSelected) {
      _selectedWashItems.add(itemValue);
      int place = i.lstname.indexOf(itemValue);
      _selectedwashcat.add(i.lstcatid.elementAt(place));
    } else {
      int place = _selectedWashItems.indexOf(itemValue);
      _selectedWashItems.remove(itemValue);
      _selectedwashcat.removeAt(place);
    }
  }

  void _meshItemChange(String itemValue, bool isSelected, nameid i) {
    if (isSelected) {
      _selectedMeshItems.add(itemValue);
      int place = i.lstname.indexOf(itemValue);
      _selectedmeshcat.add(i.lstcatid.elementAt(place));
    } else {
      int place = _selectedMeshItems.indexOf(itemValue);
      _selectedMeshItems.remove(itemValue);
      _selectedmeshcat.removeAt(place);
    }
  }

  _showMeshCategory(nameid ijk) async {
    await showDialog<nameid>(
      context: context,
      builder: (BuildContext context) {
        // int? selectedRadio = 0;
        return AlertDialog(
          title: const Text('Select Category'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: ListBody(
                  children: List.generate(ijk.lstname.length, (index) {
                return CheckboxListTile(
                    value: _selectedWashItems.contains(ijk.lstname[index]),
                    title: Text(ijk.lstname[index]),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (v) {
                      _washItemChange(ijk.lstname[index], v!, ijk);

                      setState(() {});
                    });
              })),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<UserAuthProvider>(context, listen: false)
                    .updateWashService(_selectedwashcat, context);
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  _meshcat(nameid ijk) async {
    await showDialog<nameid>(
      context: context,
      builder: (BuildContext context) {
        // int? selectedRadio = 0;
        return AlertDialog(
          title: const Text('Select Category'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: ListBody(
                  children: List.generate(ijk.lstname.length, (index) {
                return CheckboxListTile(
                    value: _selectedMeshItems.contains(ijk.lstname[index]),
                    title: Text(ijk.lstname[index]),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (v) {
                      _meshItemChange(ijk.lstname[index], v!, ijk);

                      setState(() {});
                    });
              })),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<UserAuthProvider>(context, listen: false)
                    .updateMeshService(_selectedmeshcat, context);
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  List<VendorApplied> appliedList = [];

  // @override
  // void initState() {
  //   super.initState();
  //   instance();
  // }
  //
  // late final appliedData;
  //
  // instance() async {
  //   appliedData = Provider.of<AdminAuthProvider>(context, listen: false);
  // }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<VendorApplied>(
              future: AdminAuthProvider.getVendorApplied(),
              builder: (context, snapshot) {
                return snapshot.hasError
                    ? const Padding(
                        padding: EdgeInsets.only(top: 300),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            'Something Went Wrong, \nPlease ask admin for further assistance Thank you.',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      )
                    : snapshot.connectionState == ConnectionState.waiting
                        ? Padding(
                            padding: EdgeInsets.only(top: 320),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 35.h, horizontal: 15.w),
                            child: Column(
                              children: [
                                const CustomLogo(),
                                SizedBox(height: 15.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Services',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 30.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/wash_one.svg',
                                      width: 130.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Column(
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: 5,
                                      children: snapshot.data!.data == null
                                          ? []
                                          : snapshot.data!.data!.wash!
                                              .map(
                                                (e) => Chip(
                                                  backgroundColor: Colors.white,
                                                  labelStyle: TextStyle(
                                                    color:
                                                        CustomColor().mainColor,
                                                    fontSize: 16,
                                                  ),
                                                  label: Text(e.category!.name
                                                      .toString()),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                    SizedBox(height: 10.h),
                                    CustomButton(
                                      onTextPress: () async {
                                        nameid catidaname = nameid();
                                        await UserAuthProvider.getWashNames()
                                            .then(
                                                (value) => catidaname = value);
                                        return _showMeshCategory(catidaname);
                                      },
                                      buttonText: 'Select Wash Service',
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/mesh_one.svg',
                                      width: 130.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Column(
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: 5,
                                      children: snapshot.data!.data == null
                                          ? []
                                          : snapshot.data!.data!.mesh!
                                              .map(
                                                (e) => Chip(
                                                  backgroundColor: Colors.white,
                                                  labelStyle: TextStyle(
                                                    color:
                                                        CustomColor().mainColor,
                                                    fontSize: 16,
                                                  ),
                                                  label: Text(e.category!.name
                                                      .toString()),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                    SizedBox(height: 10.h),
                                    CustomButton(
                                      onTextPress: () async {
                                        nameid catidaname = nameid();
                                        await UserAuthProvider.getMeshNames()
                                            .then(
                                                (value) => catidaname = value);
                                        return _meshcat(catidaname);
                                      },
                                      buttonText: 'Select Mesh Service',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
              }),
        ),
      ),
    );
  }
}

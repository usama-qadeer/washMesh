// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wash_mesh/models/admin_models/wash_category_model.dart';
import 'package:wash_mesh/user_screens/user_orders_screen.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_colors.dart';

import '../../models/user_models/wash_categories_model.dart' as um;
import '../models/user_models/place_order_model.dart';
import '../providers/user_provider/user_auth_provider.dart';
import '../widgets/custom_logo.dart';

class WashBookScreen extends StatefulWidget {
  static late List<um.Data> data;

  static late String name;
  static late dynamic price;

  WashBookScreen(List<um.Data> d, String n, id, fixedPrice, {super.key}) {
    data = d;
    name = n;
    price = fixedPrice;
    // print(data);
  }

  @override
  State<WashBookScreen> createState() => _WashBookScreenState();
}

class _WashBookScreenState extends State<WashBookScreen> {
  TextEditingController desp = TextEditingController();
  final List<String> _catname = [];
  final List<String> _carname = [];
  final List<int> _carnameid = [];
  final List<int> _attval = [];
  final List<String> rates = [];

  String? catname;
  String? price;
  String? attributeRate;
  String? carname;
  int _catid = 0;
  int _att_id = 0;
  int _att_val = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < WashBookScreen.data.length; i++) {
      if (WashBookScreen.name == WashBookScreen.data[i].name) {
        _catname.add(WashBookScreen.data[i].name);
        _catid = (WashBookScreen.data[i].id);

        for (int j = 0;
            j < WashBookScreen.data.elementAt(i).catAttribute!.length;
            j++) {
          // rates.add(WashBookScreen.data[j]);

          for (int k = 0;
              k <=
                  WashBookScreen.data
                      .elementAt(i)
                      .catAttribute!
                      .elementAt(j)
                      .attribute!
                      .attributeValue!
                      .length;
              k++) {
            if (k ==
                WashBookScreen.data
                    .elementAt(i)
                    .catAttribute!
                    .elementAt(j)
                    .attribute!
                    .attributeValue!
                    .length) {
            } else {
              _carnameid.add(WashBookScreen.data
                  .elementAt(i)
                  .catAttribute!
                  .elementAt(j)
                  .attribute!
                  .attributeValue!
                  .elementAt(k)
                  .id);
              _carname.add(WashBookScreen.data
                  .elementAt(i)
                  .catAttribute!
                  .elementAt(j)
                  .attribute!
                  .attributeValue!
                  .elementAt(k)
                  .name);
              _attval.add(int.parse(WashBookScreen.data
                  .elementAt(i)
                  .catAttribute!
                  .elementAt(j)
                  .attribute!
                  .attributeValue!
                  .elementAt(k)
                  .attributeId));
              attributeRate = WashBookScreen.data
                  .elementAt(i)
                  .catAttribute!
                  .elementAt(j)
                  .attribute!
                  .rate;
              rates.add(attributeRate!);
            }
            // print("8888 $attributeRate");
          }
        }
        setState(() {});
      }
    }
    //print("eeeeee$attributeRate");
    catname = WashBookScreen.name;
    price = WashBookScreen.price;
    carname = _carname.first;
    UserAuthProvider.getMeshCategories();
    print(
        "fffffffffffffffffffff${WashBookScreen.data[0].catAttribute!.first.attribute!.rate}");
  }

  File? attachment;

  dynamic base64Attachment;

  attachmentGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
    );

    if (imageFile == null) {
      return;
    }
    attachment = File(imageFile.path);
    final imageByte = attachment!.readAsBytesSync();
    setState(() {
      base64Attachment = "data:image/png;base64,${base64Encode(imageByte)}";
      Navigator.of(context).pop();
    });
  }

  attachmentCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 300,
    );

    if (imageFile == null) {
      return;
    }
    attachment = File(imageFile.path);
    final imageByte = attachment!.readAsBytesSync();
    setState(() {
      base64Attachment = "data:image/png;base64,${base64Encode(imageByte)}";
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        "fffffffffffff${WashCategoryModel().data?.elementAt(1).catAttribute?.elementAt(1).attribute?.attributeValue}");

    var totalAmount = int.parse(price!) + int.parse(attributeRate!);
    print("hhhhhhh${attributeRate}");
    return CustomBackground(
      op: 0.1,
      ch: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 12.w),
          child: Column(
            children: [
              const CustomLogo(),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/wash_one.svg',
                    width: 130.w,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Container(
                width: 320.w,
                height: 65.h,
                decoration: BoxDecoration(
                  color: CustomColor().mainColor,
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            catname!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: 320.w,
                height: 65.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: DropdownButtonFormField<String>(
                  value: carname,
                  // hint: const Text(
                  //   'Gender',
                  //   style: TextStyle(color: Colors.grey),
                  // ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your type';
                    }
                    return null;
                  },
                  items: _carname
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  borderRadius: BorderRadius.circular(32.r),
                  onChanged: (String? value) {
                    _att_val = _carname.indexOf(value!);
                    _att_id = _attval.elementAt(_att_val);
                    _att_val = _carnameid.elementAt(_att_val);
                    setState(() {
                      attributeRate = rates.elementAt(_carname.indexOf(value));
                    });
                    // print(rates.elementAt(_carname.indexOf(value)));
                  },
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.r),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.r),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.r),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
              // SizedBox(height: 15.h),
              // GestureDetector(
              //   onTap: () {},
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Container(
              //         height: 42.h,
              //         width: 40.w,
              //         decoration: BoxDecoration(
              //           color: Colors.green.shade900,
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //         child: const Icon(
              //           Icons.add,
              //           size: 26,
              //           color: Colors.white,
              //         ),
              //       ),
              //       SizedBox(width: 22.w),
              //     ],
              //   ),
              // ),
              SizedBox(height: 15.h),
              InkWell(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Choose an Option:'),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        ElevatedButton(
                          onPressed: attachmentGallery,
                          child: const Text('Gallery'),
                        ),
                        ElevatedButton(
                          onPressed: attachmentCamera,
                          child: const Text('Camera'),
                        ),
                      ],
                    );
                  },
                ),
                child: Container(
                  width: 320.w,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Attach Pictures',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 18.sp,
                        ),
                      ),
                      // const Text(
                      //   '(Optional)',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w700,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      SizedBox(width: 70.w),
                      const Icon(
                        Icons.attachment_outlined,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: attachment != null
                        ? Image.file(
                            attachment!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : const Text(
                            'No Image Taken',
                            textAlign: TextAlign.center,
                          ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 320.w,
                    height: 180.h,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'Description (Optional)',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                        TextField(
                          controller: desp,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Amount to be Paid:',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$totalAmount',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300.w,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            elevation: 20,
                            shadowColor: CustomColor().shadowColor,
                            backgroundColor: CustomColor().mainColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                            ),
                          ),
                          onPressed: () async {
                            List<OrderAttribute> lst = [];
                            OrderAttribute oa = OrderAttribute(
                              attributeId: _att_id,
                              attributeValue: _att_val,
                            );
                            List<String> picList = [];
                            picList.add(base64Attachment);
                            lst.add(oa);
                            String dt = DateTime.now().toString();
                            List<String> lstdt = dt.split(':');
                            dt = "${lstdt[0]}:${lstdt[1]}";
                            PlaceOrderModel p = PlaceOrderModel(
                              amount: totalAmount.toString(),
                              description: desp.text.toString(),
                              picture: picList,
                              orderAttribute: lst,
                              serviceAt: dt,
                              categoryId: _catid,
                            );
                            await Provider.of<UserAuthProvider>(context,
                                    listen: false)
                                .placeOrder(p, context);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserOrdersScreen(),
                              ),
                            );
                          },
                          child: const Text('Book Now'),

                          // CustomButton(
                          //   onTextPress: () {},
                          //   buttonText: 'Book Later',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wash_mesh/user_screens/mesh_book_screen.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';

import '../models/user_models/mesh_categories_model.dart' as um;
import '../providers/user_provider/user_auth_provider.dart';

class MeshCategory extends StatefulWidget {
  const MeshCategory({Key? key}) : super(key: key);

  @override
  State<MeshCategory> createState() => _MeshCategoryState();
}

class _MeshCategoryState extends State<MeshCategory> {
  List<um.MeshCategoryModel> catlst = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    instance();
  }

  late final userData;

  instance() async {
    userData = Provider.of<UserAuthProvider>(context, listen: false);
  }

  // final List<um.MeshCategoryModel> _data = [];
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<um.MeshCategoryModel>(
            future: UserAuthProvider.getMeshCategories(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Padding(
                      padding: EdgeInsets.only(top: 320),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 45.h, horizontal: 12.w),
                      child: Column(
                        children: [
                          const CustomLogo(),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/mesh_one.svg',
                                width: 130.w,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemCount: snapshot.data!.data!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  List<um.Data> data = snapshot.data!.data!;

                                  var meshCategory = snapshot.data!.data!
                                      .elementAt(index)
                                      .catAttribute;

                                  if (meshCategory!.isNotEmpty) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MeshBookScreen(
                                          data,
                                          snapshot.data!.data!
                                              .elementAt(index)
                                              .name,
                                          snapshot.data!.data!
                                              .elementAt(index)
                                              .id,
                                          snapshot.data!.data!
                                              .elementAt(index)
                                              .fixedPrice,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Something went wrong!!!');
                                  }
                                },
                                child: Column(
                                  children: [
                                    Image.network(
                                      snapshot.data!.data!
                                          .elementAt(index)
                                          .image,
                                      fit: BoxFit.contain,
                                      width: 80.w,
                                      height: 80.h,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "${snapshot.data!.data!.elementAt(index).name}",
                                        // overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Text(
                                'Featured',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 30.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              3,
                              (index) => InkWell(
                                onTap: () async {
                                  List<um.Data> data = snapshot.data!.data!;

                                  var meshCategory = snapshot.data!.data!
                                      .elementAt(index)
                                      .catAttribute;

                                  if (meshCategory!.isNotEmpty) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => MeshBookScreen(
                                          data,
                                          snapshot.data!.data!
                                              .elementAt(index)
                                              .name,
                                          snapshot.data!.data!
                                              .elementAt(index)
                                              .id,
                                          snapshot.data!.data!
                                              .elementAt(index)
                                              .fixedPrice,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Something went wrong!!!');
                                  }
                                },
                                child: Column(
                                  children: [
                                    Image.network(
                                      snapshot.data!.data!
                                          .elementAt(index)
                                          .image,
                                      fit: BoxFit.contain,
                                      width: 80.w,
                                      height: 80.h,
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      snapshot.data!.data!
                                          .elementAt(index)
                                          .name,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}

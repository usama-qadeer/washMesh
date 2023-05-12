import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wash_mesh/user_screens/mesh_category_screen.dart';
import 'package:wash_mesh/user_screens/wash_category_screen.dart';
import 'package:wash_mesh/widgets/custom_background.dart';

class WashMeshDialog extends StatelessWidget {
  const WashMeshDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: AlertDialog(
        backgroundColor: Colors.transparent.withOpacity(0.0),
        content: Column(
          children: [
            Text(
              'Categories',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
              ),
            ),
            SizedBox(height: 280.h),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const WashCategory(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/svg/wash_one.svg',
                    width: 130.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MeshCategory(),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/svg/mesh_one.svg',
                      width: 130.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

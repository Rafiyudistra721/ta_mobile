// ignore_for_file: must_be_immutable

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ta_mobile/app/data/Models/buku_model.dart';
import 'package:ta_mobile/app/data/Models/ulasan_model.dart';
import 'package:ta_mobile/app/data/Models/user_model.dart';
import 'package:ta_mobile/app/utils/colors.dart';
import 'package:ta_mobile/app/utils/my_drawer.dart';

import '../controllers/manage_ulasan_controller.dart';

class ManageUlasanView extends GetView<ManageUlasanController> {
  BukuModel buku = Get.arguments ?? BukuModel();
  ManageUlasanView({Key? key}) : super(key: key);
  var columns = const [
    DataColumn(label: Text('Nama Pengguna', style: TextStyle(fontSize: 20))),
    DataColumn(label: Text('Ulasan', style: TextStyle(fontSize: 20))),
    DataColumn(label: Text('Rating', style: TextStyle(fontSize: 20))),
    DataColumn(label: Text('Aksi', style: TextStyle(fontSize: 20))),
  ];
  @override
  Widget build(BuildContext context) {
    controller.modelToController(buku);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer
            MyDrawer(),
            // first half of page
            Expanded(
              flex: 1,
              child: AdaptiveScrollbar(
                controller: controller.verticalScrollController,
                underColor: Colors.blueGrey.withOpacity(0.3),
                sliderDefaultColor: active.withOpacity(0.7),
                sliderActiveColor: active,
                child: SingleChildScrollView(
                  controller: controller.verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text('Daftar Ulasan: ${buku.judul}',
                                style: GoogleFonts.urbanist(fontSize: 30)),
                          ),
                        ],
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.all(16),
                          child: controller.listUlasan.isEmpty
                              ? const Center(child: Text('Belum ada ulasan yang diberikan oleh pengguna'))
                              : PaginatedDataTable(
                                  showCheckboxColumn: false,
                                  showFirstLastButtons: true,
                                  columns: columns,
                                  source: MyData(controller.listUlasan, controller.users),
                                  columnSpacing:
                                      MediaQuery.of(context).size.width * .03,
                                  horizontalMargin: 30,
                                  rowsPerPage: 5,
                                  dataRowMaxHeight: 200,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  ManageUlasanController manageUlasanController = ManageUlasanController();
  final List<UlasanModel> listUlasan;
  final List<UserModel> users;

  MyData(this.listUlasan, this.users);
  @override
  DataRow getRow(int index) => DataRow.byIndex(
    index: index, 
    cells: [
        DataCell(Text("${users.firstWhere((cat) => cat.id == listUlasan[index].userId).username}",
            style: GoogleFonts.urbanist(fontSize: 17))),
        DataCell(Text("${listUlasan[index].ulasan}",
            style: GoogleFonts.urbanist(fontSize: 17))),
        DataCell(
          RatingBarIndicator(
            rating: listUlasan[index].rating!,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 30,
              direction: Axis.horizontal,
            )),
        DataCell(ElevatedButton(
            onPressed: () async {
              manageUlasanController.delete(listUlasan[index]);
            },
            child: const Icon(Icons.delete_rounded))),
      ]);

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => listUlasan.length;
  @override
  int get selectedRowCount => 0;
}

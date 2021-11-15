import 'package:cached_network_image/cached_network_image.dart';
import 'package:declarative_refresh_indicator/declarative_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/base/constants/ApiEndpoint.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/CustomTextField.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/SearchController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/screen/FilterChangeDescription.dart';
import 'package:zacharchive_flutter/screen/SearchedDescription_9.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/UserRepository.dart';

class SearchPlantScreen extends StatefulWidget {
  String from;
  String id;

  SearchPlantScreen(this.from, this.id);

  @override
  _SearchPlantScreenState createState() => _SearchPlantScreenState();
}

class _SearchPlantScreenState extends State<SearchPlantScreen> {
  FocusNode messageFocus = FocusNode();

  SearchController controller = Get.put(SearchController());
  var imagePath = "";
  var url = "";

  var location = 'Location';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refreshData();
    getLocation();
  }

  Future<void> getLocation() async {
    var user = await getUser();
    location = user!.data!.location!;
    print('keyloca' + location);
  }

  void _refreshData() async {
    Future.delayed(Duration.zero, () async {
      print('_refreshData_called' + widget.id);

      if (widget.from == Strings.filterChange) {
        url = ApiEndpoint.BASE_URL +
            ApiEndpoint.FILTER_PRODUCT_LIST +
            "/" +
            widget.id;
        imagePath = ApiEndpoint.FILTER_IMAGE_PATH;
      } else {
        url = ApiEndpoint.BASE_URL +
            ApiEndpoint.PLANT_PRODUCT_LIST +
            "/" +
            widget.id;
        imagePath = ApiEndpoint.MEDIA_PATH;
      }

      controller.loading.value = true;
      await controller.fetchPlantProductListAPI(
          categoryId: widget.id, url: url);
      if (mounted) controller.loading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GetX<SearchController>(builder: (controller) {
          return ShowUp(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Images.bgImage), fit: BoxFit.cover)),
              child: Column(
                children: [
                  showTopWidget(),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          /* height:
                              screenHeight(context) * getScreenLength(context),*/
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                showSearchView(),
                                DeclarativeRefreshIndicator(
                                    refreshing: controller.loading.value,
                                    color: colorPrimary,
                                    onRefresh: _refreshData,
                                    child: getList())
                              ],
                            ),
                          ),
                        ),
                        showScanHomeImage(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget getList() {
    var _mediaQueryData = MediaQuery.of(context);
    if (controller.plantProductListTwo.value.status == null ||
        controller.plantProductListTwo.value.status == "0") {
      if (controller.noDataFound.value)
        return ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (ctx, index) {
            return noDataFoundWidget(
                _mediaQueryData.size.height, Images.logoWhite, "No Product Found");
          },
        );
      else
        return Container(
          height: 100,
        );
    } else {
      return Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 100),
          child: showList());
      // }
    }
  }

  Widget showList() {
    print('listKaif' +
        controller.plantProductListTwo.value.data!.length.toString());

    return CustomList(
        shrinkWrap: true,
        axis: Axis.vertical,
        list: controller.plantProductListTwo.value.data!,
        child: (data, i) {
          return GestureDetector(
            onTap: () {
              hideKeyboard(context);

              if (widget.from == Strings.filterChange)
                FilterChangeDescription(widget.id).navigate();
              else
                SearchedDescription(
                        controller.plantProductListTwo.value.data![i],
                        Strings.search,
                        controller.plantProductListTwo.value.data![i].id!
                            .toString())
                    .navigate();
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
              elevation: 10,
              child: Padding(
                padding: 5.paddingAll(),
                child: Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0.5, 0.5),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 2, child: boxImage(i)),
                          SizedBox(width: 10),
                          Expanded(
                              flex: 3,
                              child: Container(
                                height: 130,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    showTitle(
                                        title: controller.plantProductListTwo
                                            .value.data![i].title!,
                                        size: 20,
                                        weight: FontWeight.w600,
                                        line: 1),
                                    5.horizontalSpace(),
                                    MyDottedSeparator(),
                                    4.horizontalSpace(),
                                    showTitle(
                                        title: controller.plantProductListTwo
                                            .value.data![i].name!,
                                        size: 16,
                                        weight: FontWeight.w500,
                                        line: 1),
                                    5.horizontalSpace(),
                                    showTitle(
                                        title: controller.plantProductListTwo
                                            .value.data![i].description!,
                                        size: 14,
                                        weight: FontWeight.w400,
                                        line: 2),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget boxImage(int i) {
    return Container(
      margin: 5.marginAll(),
      child: CachedNetworkImage(
        imageUrl:
            imagePath + controller.plantProductListTwo.value.data![i].imageUrl!,
        imageBuilder: (context, imageProvider) {
          return categoryImageSecond(
              imageProvider, 140, 100, BoxShape.rectangle);
        },
        placeholder: (context, url) {
          return showPlaceholderImage(
              image: Images.placeholderImage, width: 100, height: 120);
        },
        errorWidget: (context, url, error) {
          return showPlaceholderImage(
              image: Images.errorImage, width: 100, height: 120);
        },
      ),
    );
  }

  showTopWidget() {
    return Padding(
      padding: 5.paddingAll(),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: GestureDetector(
                  onTap: () {
                    if (controller.searchingText.value.isNotEmpty) {
                      hideKeyboard(context);
                      controller.searchingText.value = '';
                    } else {
                      //delete controller from memory
                      Get.delete<SearchController>();

                      Get.back();
                    }
                  },
                  child: backButton()),
            ),
            5.verticalSpace(),
            Expanded(
              flex: 7,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    showText(
                        color: Colors.white,
                        text: widget.from,
                        textSize: 20,
                        fontWeight: FontWeight.w400,
                        maxlines: 1)
                  ],
                ),
              ),
            ),
            showNotificationDrawerMenu(
                isShowNotification: true, context: context),
          ]),
    );
  }

  showSearchView() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: CustomTextField(
        cursorColor: Colors.black,
        radius: 7,
        iconColor: Colors.black,
        boarder: true,
        hintStyle: null,
        controller: controller.searchTextController,
        autoFocus: false,
        labelStyle: TextStyle(color: Colors.black),
        onTextChanged: (query) {
          print('query' + query);

          if (query.isEmpty) {
            controller.searchTextController.text = '';
            hideKeyboard(context);
          }

          controller.performFilter(query);
        },
        focusNode: messageFocus,
        activePrefix: Images.search,
        activeSuffix: Images.close,
        inActivePrefix: Images.search,
        fillColor: Colors.white,
        hint: 'Search ..',
        textStyle: GoogleFonts.nunito(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal),
      ),
    );
  }
}

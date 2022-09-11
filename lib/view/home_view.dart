import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../core/constant/application_constans.dart';
import '../core/key/local_key.dart';
import '../core/model/post.dart';
import '../core/widgets/bottom_button.dart';
import '../core/widgets/core_widget.dart';
import '../core/widgets/drawer.dart';
import '../core/widgets/file_control_widget.dart';
import '../core/widgets/pxHeight.dart';
import '../viewmodel/home_view_model.dart';
import 'contact.dart';
import 'order_details_view.dart';
import 'post_detail.dart';

class HomeView extends StatelessWidget {
  const HomeView({required this.id, Key? key}) : super(key: key);
  final int id;
  @override
  Widget build(BuildContext context) {
    return MyStatefulWidget(id: id);
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  HomeViewModel viewModel = HomeViewModel();
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  void initState() {
    viewModel.setID(widget.id);
    viewModel.fetchJobs(0);
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _widgetOptions(HomeViewModel model, int i) {
      if (i == 0) {
        if (model.state == HomeState.BUSY) {
          return buildLoadingWidget();
        } else if (model.state == HomeState.ERROR) {
          return buildErrorWidget();
        } else {
          return RefreshIndicator(
              displacement: 250,
              strokeWidth: 3,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                await model.fetchJobs(0);
              },
              child: _buildListView(context, model));
        }
      } else if (i == 1) {
        return const OrderDetails();
      } else {
        return const Profile();
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 47, 26),
      drawer: const DrawerWidget(),
      appBar: buildAppBar(),
      body: ChangeNotifierProvider<HomeViewModel>(
          create: (BuildContext context) => viewModel,
          child: Consumer<HomeViewModel>(builder: (context, model, _) {
            return Center(
              child: _widgetOptions(model, _selectedIndex),
            );
          })),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.bagShopping),
            label: 'Sipraişlerim',
          ),
          BottomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.addressBook),
            label: LocaleKeys.contact.tr(),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 29, 83, 14),
        onTap: _onItemTapped,
      ),
      /*  */
    );
  }
}

class ContactWidget extends StatelessWidget {
  const ContactWidget({
    Key? key,
  }) : super(key: key);

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Index 2: School',
      style: optionStyle,
    );
  }
}

PagedListView _buildListView(BuildContext context, HomeViewModel homeViewModel) {
  return PagedListView<int, Post>(
    pagingController: homeViewModel.pagingController,
    builderDelegate: PagedChildBuilderDelegate<Post>(
      itemBuilder: (context, item, index) => buildListItem(context, item, homeViewModel),
    ),
  );
}

Widget buildListItem(BuildContext context, Post item, HomeViewModel homeViewModel) {
  return Container(
      padding: const EdgeInsets.all(5.0),
      /* decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),*/
      child: bodyColumn(item, context, homeViewModel));
}

AppBar buildAppBar() {
  return AppBar(
    title: Text(LocaleKeys.main_title.tr()),
  );
}

Center buildErrorWidget() => Center(child: Text(LocaleKeys.internet_error.tr()));

Center buildLoadingWidget() => const Center(child: CircularProgressIndicator());
Widget bodyColumn(Post homePost, BuildContext context, HomeViewModel homeViewModel) {
  bool isFile = homePost.attributes!.media!.data == null;
  String fileType = "";
  if (!isFile) {
    String images = homePost.attributes!.media!.data![0].attributes!.mime!;
    fileType = images.split("/")[0];
    if (images.contains("pdf")) fileType = "pdf";
  }
  var x65Height = context.dynamicHeight(0.65);
  var _return = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
        child: Text(
          LocaleKeys.child_name.tr() + homePost.attributes!.baslik!,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      PxHeight(),
      fileControlWidget(fileType, ApplicationConstants.URL + homePost.attributes!.media!.data![0].attributes!.url!, context),
      PxHeight(),
      BottomButton(
        fileType: fileType,
        homePost: homePost,
      )
    ],
  );
  return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetail(post: homePost, id: homePost.id!, fileType: fileType)),
        );
      },
      child: _return);
}

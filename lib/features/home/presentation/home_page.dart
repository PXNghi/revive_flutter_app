import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/location/bloc/location_bloc.dart';
import 'package:revive_flutter_project/core/widgets/my_bottom_nav_bar.dart';
import 'package:revive_flutter_project/core/widgets/product_item.dart';
import 'package:revive_flutter_project/features/home/bloc/home_bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Padding(
            padding: pageHorizontalPadding,
            child: BlocConsumer<LocationBloc, LocationState>(
              listener: (context, state) {
                if (state is PermissionDeniedLocationState) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Quyền truy cập bị từ chối"),
                  ));
                }

                if (state is ErrorLocationState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                  ));
                }
              },
              builder: (context, state) {
                if (state is FetchingSuccessLocationState) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(redLocationIcon, height: 30, width: 30),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Địa chỉ",
                              style: contentStyle,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              state.address ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: contentStyle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(bellIcon, height: 30, width: 30),
                      ),
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(redLocationIcon, height: 30, width: 30),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Địa chỉ",
                            style: contentStyle,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            "",
                            overflow: TextOverflow.ellipsis,
                            style: contentStyle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(bellIcon, height: 30, width: 30),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: pageHorizontalPadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: screenSize.height * 0.3,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                ),
                items: bannerImageList.map((i) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      i,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24.0),
              _buildTitleSection(title: "Bảng giá", isHasAll: true),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 285,
                width: double.infinity,
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => ProductItem(
                    image: bannerImage,
                    productName: "Red Iron",
                    productCategory: "Iron",
                    productPrice: "100.000",
                  ),
                  itemCount: 5,
                ),
              ),
              _buildTitleSection(
                title: "Các chi nhánh khu vực",
                isHasAll: true,
                onTap: () {
                  context.pushNamed("branch-list");
                },
              ),
              const SizedBox(height: 10.0),
              _buildMapView(),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection({
    String? title,
    bool? isHasAll,
    VoidCallback? onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title ?? "",
          style: titleStyle,
        ),
        Visibility(
          visible: isHasAll == true,
          child: GestureDetector(
            onTap: onTap ?? () {},
            child: Text(
              "Xem tất cả",
              style:
                  contentStyle.copyWith(color: grayContentColor, fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapView() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          return SizedBox(
            height: 250,
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(10.7586869, 106.6689799),
                initialZoom: 10.0,
              ),
              children: [
                openStreetMapTileLayer,
                MarkerLayer(
                  markers: state.branches
                      .map(
                        (marker) => Marker(
                          point: LatLng(
                            marker.location.coordinates[1],
                            marker.location.coordinates[0],
                          ),
                          width: 100.0,
                          height: 100.0,
                          child: const Icon(
                            Icons.location_pin,
                            color: alertColor,
                            size: 50.0,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.revive_flutter_project',
      );
}



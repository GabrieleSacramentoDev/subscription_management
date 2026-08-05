import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subscription_management/src/modules/streaming_management/data/models/streaming_model.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/streaming_entity.dart';
import 'package:subscription_management/src/modules/home/presentation/widgets/my_subscription_info_widget.dart';
import 'package:subscription_management/src/modules/shared/widgets/custom_form.dart';
import 'package:subscription_management/src/routes/router.dart';
import 'package:subscription_management/src/utils/app_strings.dart';

@RoutePage(name: 'SelectStreamingPageRoute')
class SelectStreamingPage extends StatefulWidget {
  const SelectStreamingPage({super.key});

  @override
  State<SelectStreamingPage> createState() => _SelectStreamingPageState();
}

class _SelectStreamingPageState extends State<SelectStreamingPage> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<StreamingEntity>>? _streamingsFuture;
  Future<List<StreamingEntity>> loadStreamings(BuildContext context) async {
    try {
      final String response = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/streaming_list.json');
      final List<dynamic> data = jsonDecode(response);
      return data
          .map((json) => StreamingModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      debugPrint('Erro ao carregar streamings: $e');
      return [];
    }
  }

  List<StreamingEntity> allStreamings = [];
  List<StreamingEntity> filteredStreamings = [];
  String _searchText = '';

  final strings = SubscriptionsManagementStrings();
  @override
  void initState() {
    super.initState();
    _streamingsFuture = loadStreamings(context);

    _searchController.addListener(() {
      _filterStreamings();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterStreamings() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _searchText = query;
      filteredStreamings = allStreamings.where((streaming) {
        return streaming.streamingName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(243, 243, 243, 1),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color.fromRGBO(111, 86, 221, 1),
              ),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Text(
              strings.addSubscription,
              style: TextStyle(
                fontSize: 20.sp,
                color: const Color.fromRGBO(111, 86, 221, 1),
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          backgroundColor: const Color.fromRGBO(243, 243, 243, 1),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: FutureBuilder<List<StreamingEntity>>(
            future: _streamingsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    strings.errorToLoadSubscriptions,
                    style: TextStyle(fontSize: 16.sp, color: Colors.red),
                  ),
                );
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    strings.noSubscriptionsFound,
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                );
              }
              if (allStreamings.isEmpty) {
                allStreamings = snapshot.data!;
                if (_searchText.isEmpty) {
                  filteredStreamings = allStreamings;
                } else {
                  filteredStreamings = allStreamings.where((streaming) {
                    return streaming.streamingName.toLowerCase().contains(
                      _searchText,
                    );
                  }).toList();
                }
              }
              if (filteredStreamings.isEmpty && _searchText.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 32.h),
                      child: CustomForm(
                        controller: _searchController,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                        hintText: strings.searchStreaming,
                        semanticLabel: strings.searchStreaming,
                      ),
                    ),

                    Center(
                      child: Text(
                        strings.noSubscriptionsFoundWithSearchText.replaceAll(
                          '{p1}',
                          _searchText,
                        ),

                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  CustomForm(
                    controller: _searchController,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                    hintText: strings.searchStreaming,
                    semanticLabel: strings.searchStreaming,
                  ),

                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
                      itemCount: filteredStreamings.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: () {
                              context.pushRoute(
                                StreamingManagementPageRoute(
                                  newStreaming: true,
                                  streaming: const StreamingEntity(
                                    streamingName: '',
                                    streamingId: '',
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  strings.costumizeYourSubscription,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: const Color.fromRGBO(
                                      111,
                                      86,
                                      221,
                                      1,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.sp,
                                  color: const Color.fromRGBO(111, 86, 221, 1),
                                ),
                              ],
                            ),
                          );
                        }

                        final streaming = filteredStreamings[index - 1];
                        return MySubscriptionInfoWidget(
                          onTap: () {
                            context.pushRoute(
                              StreamingManagementPageRoute(
                                streaming: streaming,
                                newStreaming: true,
                              ),
                            );
                          },
                          streamingServiceName: streaming.streamingName,
                          streamingServiceImage: Image.asset(
                            streaming.streamingImage!,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prepaud/common/app_button.dart';
import 'package:prepaud/features/home/cubit/home_cubit.dart';
import 'package:prepaud/features/home/widget/result_tile.dart';
import 'package:prepaud/features/home/widget/setting_card.dart';
import 'package:prepaud/features/test/presentation/test_page.dart';
import 'package:prepaud/features/test/widget/option_tile.dart';
import 'package:prepaud/utils/app_colors.dart';
import 'package:prepaud/utils/app_constant.dart';
import 'package:prepaud/utils/healper.dart';
import 'package:prepaud/utils/ui_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeCubit>().fetchPreviousResults();
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppConstant.appName,
          style: fsHeadLine1(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
        return state is HomePageLoaded
            ? Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  state.results.isNotEmpty
                      ? Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            10.spaceY,
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Text("Previous Scores : ",style: fsHeadLine4(color: Colors.black,fontWeight: FontWeight.w500)),
                            ),
                            Expanded(
                              child: ListView(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  children: state.results.map((e) => ResultTile(result: e)).toList(),
                                ),
                            ),
                          ],
                        ),
                      )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('Assets/images/quiz_banner.png'),
                            10.spaceY,
                            Text(
                              "Play Quiz to View your Score Here",
                              style: fsHeadLine3(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SettingCard(data: state.numOfQues.toString(), upFunc: questionsUp, downFunc: questionsDown),
                      SettingCard(data: state.lvl.toString(), upFunc: levelUp, downFunc: levelDown),
                    ],
                  ),
                  InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TestPage(
                                  totalQuetion: state.numOfQues,
                                  correctPoint: state.points[0],
                                  wrongPoint: state.points[1]))),
                      child: const AppButton(text: 'Begin', isEnabled: true)),
                ],
              )
            : const CircularProgressIndicator();
      }),
    );
  }

  void questionsUp() {
    context.read<HomeCubit>().questionUp();
  }

  void questionsDown() {
    context.read<HomeCubit>().questionUp();
  }

  void levelUp() {
    context.read<HomeCubit>().levelUp();
  }

  void levelDown() {
    context.read<HomeCubit>().levelDown();
  }
}

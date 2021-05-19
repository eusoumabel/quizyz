import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quizyz/bloc/ranking_bloc.dart';
import 'package:quizyz/components/quizyz_app_button.dart';
import 'package:quizyz/model/Quiz.dart';
import 'package:quizyz/service/config/base_response.dart';
import 'package:quizyz/utils/helpers/manage_dialogs.dart';
import 'package:quizyz/utils/style/colors.dart';

class RankingPage extends StatefulWidget {
  final Quiz quiz;
  final bool hasAppBar;
  final String textButtom;
  final Function onTap;
  final bool hasButtom;

  const RankingPage(
      {Key key,
      this.quiz,
      this.hasAppBar,
      this.textButtom,
      this.onTap,
      this.hasButtom})
      : super(key: key);
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  RankingBloc _bloc = RankingBloc();

  @override
  void initState() {
    super.initState();
    _jogadoresStream();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  _jogadoresStream() async {
    await _bloc.getJogadoresQuiz(cod: widget.quiz.id);
    _bloc.jogadoresStream.listen((event) async {
      switch (event.status) {
        case Status.COMPLETED:
          Navigator.pop(context);
          break;
        case Status.LOADING:
          ManagerDialogs.showLoadingDialog(context);
          break;
        case Status.ERROR:
          Navigator.pop(context);
          ManagerDialogs.showErrorDialog(context, event.message);
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hasAppBar
          ? AppBar(
              centerTitle: true,
              title: Text(
                widget.quiz.titulo,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: accentColor,
                    ),
              ),
              leading: IconButton(
                icon: IconTheme(
                  data: Theme.of(context).iconTheme.copyWith(
                        color: accentColor,
                      ),
                  child: Icon(Icons.arrow_back_ios),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                GestureDetector(
                  onTap: widget.onTap,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: IconTheme(
                      data: Theme.of(context).iconTheme.copyWith(
                            color: accentColor,
                          ),
                      child: Icon(
                        Icons.delete_outline,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Container(
                  child: SvgPicture.asset(
                    "images/trophy.svg",
                    alignment: Alignment.center,
                    height: 120,
                    width: 120,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  "Ranking",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SelectableText(
                  "Cod: ${widget.quiz.id}",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    color: backgroundContainerColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(64, 40, 64, 16),
                    child: Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ana Julia",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  "10/10",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                        color: accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Ana Julia",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    "10/10",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          color: accentColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        widget.hasButtom
                            ? Padding(
                                padding: const EdgeInsets.only(top: 32.0),
                                child: QuizyzAppButton(
                                  onTap: widget.onTap,
                                  title: widget.textButtom,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

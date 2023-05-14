import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:infotm/models/isar_user.dart';
import 'package:infotm/services/isar.dart';
import 'package:infotm/ui_components/custom_app_bar.dart';
import 'package:infotm/ui_components/custom_textfield.dart';
import 'package:infotm/ui_components/ui_specs.dart';

class TripQuestionaire extends StatefulWidget {
  const TripQuestionaire({super.key});

  @override
  State<TripQuestionaire> createState() => _TripQuestionaireState();
}

class _TripQuestionaireState extends State<TripQuestionaire> {
  bool showForm = false;
  bool showDaysQuestion = false;
  bool showInterestQuestion = false;
  bool showIndoorQuestion = false;
  bool showHistoryQuestion = false;
  bool showBusyRelaxedQuestion = false;
  bool showPhysicalQuestion = false;
  bool showNightlifeQuestion = false;
  bool showTraditionsQuestion = false;

  bool showDaysSlider = false;
  bool showInterestPicker = false;
  bool showIndoorOutdoorPicker = false;
  bool showHistorySlider = false;
  bool showBusyRelaxedPicker = false;
  bool showPhysicalConstraints = false;
  bool showNightlife = false;
  bool showTraditions = false;

  double _tripDays = 1;
  List<String> options = [
    "art",
    "history",
    "sports",
    "music",
    "technology",
    "nature"
  ];

  List<String> locationOptions = ["indoor", "outdoor", "both"];
  List<String> busyRelaxedOptions = ["busy", "relaxed"];
  List<String> boolOptions = ["yes", "no"];

  List<String> _interests = [];
  List<String> _indoor = [];
  double _historyInterest = 3;
  bool _busy = true;
  bool _physicalConstraints = false;
  bool _nightlife = false;
  bool _traditions = true;

  int currentStep = 0;

  // static const Duration textDuration = Duration(milliseconds: 0);
  static const Duration textDuration = Duration(milliseconds: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Trip planning"),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: AppMargins.L,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppMargins.M, vertical: AppMargins.M),
            child: AnimatedTextKit(
              onFinished: () {
                setState(() {
                  showForm = true;
                  showDaysQuestion = true;
                });
              },
              isRepeatingAnimation: false,
              animatedTexts: [
                TypewriterAnimatedText(
                  speed: textDuration,
                  'Welcome traveller, let\'s plan your trip to Timișoara',
                  textStyle: const TextStyle(
                      fontSize: AppFontSizes.XL, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            opacity: showForm ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppMargins.M),
              child: Center(
                child: Stepper(
                  physics: const ClampingScrollPhysics(),
                  type: StepperType.vertical,
                  currentStep: currentStep,
                  onStepCancel: () => currentStep == 0
                      ? null
                      : setState(() {
                          currentStep -= 1;
                        }),
                  onStepContinue: () {
                    animateNextStepQuestion(currentStep);
                    bool isLastStep = (currentStep == getSteps().length - 1);
                    if (isLastStep) {
                      IsarService.isarItinerary.itinerary = '{}';
                      Navigator.pushNamed(context, '/itinerary', arguments: {});
                    } else {
                      setState(() {
                        currentStep += 1;
                      });
                    }
                  },
                  onStepTapped: (step) => setState(() {
                    currentStep = step;
                  }),
                  steps: getSteps(),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: AppMargins.XL,
          )
        ],
      )),
    );
  }

  List<Step> getSteps() {
    return <Step>[
      sliderStep(
          stepIndex: 0,
          questionString: 'How many days are you planning to stay?',
          questionBool: showDaysQuestion,
          min: 1,
          max: 7),
      stringTagStep(
        stepIndex: 1,
        questionString: "What are your interests/hobbies?",
        questionBool: showInterestQuestion,
      ),
      stringTagStep(
        stepIndex: 2,
        questionString: "Where should the activities be located?",
        questionBool: showIndoorQuestion,
      ),
      sliderStep(
          stepIndex: 3,
          questionString:
              'What’s your level of interest in historical sites and museums?',
          questionBool: showHistoryQuestion,
          min: 1,
          max: 5),
      boolStep(
        stepIndex: 4,
        questionString: "Do you prefer a busy itinerary or a relaxed pace?",
        questionBool: showBusyRelaxedQuestion,
      ),
      boolStep(
        stepIndex: 5,
        questionString:
            "Do you have any physical contraints we should consider? (e.g. difficulties walking or climbing stairs)",
        questionBool: showPhysicalQuestion,
      ),
      boolStep(
        stepIndex: 6,
        questionString: "Are you interested in the local nightlife?",
        questionBool: showNightlifeQuestion,
      ),
      boolStep(
        stepIndex: 7,
        questionString: "Are you interested in local customs and traditions?",
        questionBool: showTraditionsQuestion,
      ),
    ];
  }

  Step sliderStep({
    required int stepIndex,
    required String questionString,
    required bool questionBool,
    required double min,
    required double max,
  }) {
    return Step(
      state: currentStep > stepIndex ? StepState.complete : StepState.indexed,
      isActive: currentStep >= stepIndex,
      title: Visibility(
        visible: questionBool,
        child: AnimatedTextKit(
          displayFullTextOnTap: true,
          isRepeatingAnimation: false,
          animatedTexts: [
            TypewriterAnimatedText(
              speed: textDuration,
              questionString,
              textStyle: const TextStyle(
                  fontSize: AppFontSizes.L, fontWeight: FontWeight.bold),
            ),
          ],
          onFinished: () {
            setState(() {
              showQuestionInput(stepIndex);
            });
          },
        ),
      ),
      content: Column(
        children: [
          Slider.adaptive(
              min: min,
              max: max,
              divisions: max.toInt() - 1,
              value: getValue(stepIndex),
              label: stepIndex == 0
                  ? (getValue(stepIndex).round() == min
                      ? "${getValue(stepIndex).round()} day"
                      : getValue(stepIndex) == max
                          ? "${getValue(stepIndex).round()}+ days"
                          : "${getValue(stepIndex).round()} days")
                  : "${getValue(stepIndex).round()}",
              onChanged: (value) {
                setState(() {
                  switch (currentStep) {
                    case 0:
                      _tripDays = value;
                      break;
                    case 3:
                      _historyInterest = value;
                      break;
                  }
                });
              }),
        ],
      ),
    );
  }

  Step stringTagStep({
    required int stepIndex,
    required String questionString,
    required bool questionBool,
  }) {
    return Step(
      state: currentStep > stepIndex ? StepState.complete : StepState.indexed,
      isActive: currentStep >= stepIndex,
      title: Visibility(
        visible: questionBool,
        child: AnimatedTextKit(
          displayFullTextOnTap: true,
          isRepeatingAnimation: false,
          animatedTexts: [
            TypewriterAnimatedText(
              speed: textDuration,
              questionString,
              textStyle: const TextStyle(
                  fontSize: AppFontSizes.L, fontWeight: FontWeight.bold),
            ),
          ],
          onFinished: () {
            setState(() {
              showQuestionInput(stepIndex);
            });
          },
        ),
      ),
      content: Column(
        children: [
          ChipsChoice<String>.multiple(
            choiceStyle: C2ChipStyle.filled(
              color: AppColors.sunset,
              selectedStyle: C2ChipStyle.filled(color: AppColors.burntSienna),
            ),
            value: stepIndex == 1 ? _interests : _indoor,
            onChanged: (value) {
              setState(() {
                switch (stepIndex) {
                  case 1:
                    _interests = value;
                    break;
                  case 2:
                    _indoor = value;
                    break;
                }
              });
            },
            choiceItems: C2Choice.listFrom<String, String>(
              source: stepIndex == 1 ? options : locationOptions,
              value: (i, v) => v,
              label: (i, v) => v,
            ),
          )
        ],
      ),
    );
  }

  Step boolStep({
    required int stepIndex,
    required String questionString,
    required bool questionBool,
  }) {
    return Step(
      state: currentStep > stepIndex ? StepState.complete : StepState.indexed,
      isActive: currentStep >= stepIndex,
      title: Visibility(
        visible: questionBool,
        child: AnimatedTextKit(
          displayFullTextOnTap: true,
          isRepeatingAnimation: false,
          animatedTexts: [
            TypewriterAnimatedText(
              speed: textDuration,
              questionString,
              textStyle: const TextStyle(
                  fontSize: AppFontSizes.L, fontWeight: FontWeight.bold),
            ),
          ],
          onFinished: () {
            setState(() {
              showQuestionInput(stepIndex);
            });
          },
        ),
      ),
      content: Column(
        children: [
          AnimatedOpacity(
              opacity: showDaysSlider ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              child: ChipsChoice<bool>.single(
                choiceStyle: C2ChipStyle.filled(
                  color: AppColors.sunset,
                  selectedStyle:
                      C2ChipStyle.filled(color: AppColors.burntSienna),
                ),
                value: stepIndex == 4
                    ? _busy
                    : stepIndex == 5
                        ? _physicalConstraints
                        : stepIndex == 6
                            ? _nightlife
                            : _traditions,
                onChanged: (val) {
                  setState(() {
                    stepIndex == 4
                        ? _busy = val
                        : stepIndex == 5
                            ? _physicalConstraints = val
                            : stepIndex == 6
                                ? _nightlife = val
                                : _traditions = val;
                  });
                },
                choiceItems: C2Choice.listFrom<bool, String>(
                  source: stepIndex == 4 ? busyRelaxedOptions : boolOptions,
                  value: (i, v) => i == 0 ? true : false,
                  label: (i, v) => v,
                ),
              ))
        ],
      ),
    );
  }

  void animateNextStepQuestion(int currentStep) {
    switch (currentStep) {
      case 0:
        setState(() {
          showInterestQuestion = true;
        });
        break;
      case 1:
        setState(() {
          showIndoorQuestion = true;
        });
        break;
      case 2:
        setState(() {
          showHistoryQuestion = true;
        });
        break;
      case 3:
        setState(() {
          showBusyRelaxedQuestion = true;
        });
        break;
      case 4:
        setState(() {
          showPhysicalQuestion = true;
        });
        break;
      case 5:
        setState(() {
          showNightlifeQuestion = true;
        });
        break;
      case 6:
        setState(() {
          showTraditionsQuestion = true;
        });
        break;
    }
  }

  void showQuestionInput(int stepIndex) {
    switch (stepIndex) {
      case 0:
        setState(() {
          showDaysSlider = true;
        });
        break;
      case 1:
        setState(() {
          showInterestPicker = true;
        });
        break;
      case 2:
        setState(() {
          showIndoorOutdoorPicker = true;
        });
        break;
      case 3:
        setState(() {
          showHistorySlider = true;
        });
        break;
      case 4:
        setState(() {
          showBusyRelaxedPicker = true;
        });
        break;
      case 5:
        setState(() {
          showPhysicalConstraints = true;
        });
        break;
      case 6:
        setState(() {
          showNightlife = true;
        });
        break;
      case 7:
        setState(() {
          showTraditions = true;
        });
        break;
    }
  }

  void updateValue(int currentStep, dynamic value) {
    switch (currentStep) {
      case 0:
        _tripDays = value as double;
        break;
      case 1:
        _interests = value;
        break;
      case 2:
        _indoor = value;
        break;
      case 3:
        _historyInterest = value;
        break;
      case 4:
        setState(() {
          _busy = value;
        });
        break;
      case 5:
        setState(() {
          _physicalConstraints = value;
        });
        break;
      case 6:
        setState(() {
          _nightlife = value;
        });
        break;
      case 7:
        setState(() {
          _traditions = value;
        });
        break;
    }
  }

  dynamic getValue(int currentStep) {
    switch (currentStep) {
      case 0:
        return _tripDays;
      case 1:
        return _interests;
      case 2:
        return _indoor;
      case 3:
        return _historyInterest;
      case 4:
        return _busy;
      case 5:
        return _physicalConstraints;
      case 6:
        return _nightlife;
      case 7:
        return _traditions;
    }
  }
}

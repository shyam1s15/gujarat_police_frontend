import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_bandobas/app/jsondata/EventData/Event.dart';
import 'package:e_bandobas/app/jsondata/EventData/EventApi.dart';
import '../../../../constants/enums.dart';
import '../../../Exceptions/ValidationException.dart';
import '../../../jsondata/EventPoliceCount/EventPoliceCountAPI.dart';
import '../../../jsondata/EventPoliceCount/EventPoliceCountOfAssignedTotalRequestedModel.dart';
import '../../event/views/event_view.dart';

class AssesmentController extends GetxController {
  late final selectedEventId = 0.obs;
  final events = Rxn<List<Event>>();
  final eventAssignmentCounts =
      Rxn<List<EventPoliceCountAssignedTotalRequestedModel>>();
  final eventDataSource = Rxn<EventViewDataGridSource>();

  final count = 0.obs;
  @override
  void onClose() {}

  void loadEvents() async {
    EventApi eventApi = EventApi();
    events.value = await eventApi.obtainEvents(API_Decision.Only_Failure);
    if (events.value != null && events.value!.isNotEmpty) {
      selectedEventId.value = events.value!.elementAt(0).id!.toInt();
      getEventAssignments();
    }
    events.refresh();
    eventDataSource.refresh();
    print(events.value);
    update();
  }

  void changeSelectedEvent(num? value) {
    selectedEventId.value = value!.toInt();
    getEventAssignments();
    update();
  }

  void getEventAssignments() async {
    EventPoliceCountAPI api = EventPoliceCountAPI();
    eventAssignmentCounts.value =
        await api.obtainEventPoliceCountAssignments(
            API_Decision.Only_Failure, selectedEventId.value);
  }

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  Future<EventViewDataGridSource> getEventViewDataGridSource() async {
    List<Event>? eventList = await events();
    return EventViewDataGridSource(eventList!);
  }

  Future<bool> saveEvent(String eventName, String eventDetails,
      DateTime startDate, DateTime endDate) async {
    bool result = false;
    if (eventName.isNotEmpty) {
      EventApi eventApi = EventApi();
      result = await eventApi.createEvent(API_Decision.Only_Success, eventName,
          eventDetails, startDate, endDate);
      loadEvents();
      update();
      return true;
    } else {
      ValidationException().showValidationSnackBar();
    }
    return false;
  }
}
